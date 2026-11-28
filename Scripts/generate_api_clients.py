"""Usage: curl -s <server>/v3/api-docs -o api.json && python3 Scripts/generate_api_clients.py api.json Projects/App/Sources/Networking $(grep -L "Generated from the backend OpenAPI spec" Projects/App/Sources/Networking/*.swift)

Generate Swift API clients for selected OpenAPI operations, following the repo's Networking conventions."""
import json, re, sys

spec = json.load(open(sys.argv[1]))
out_dir = sys.argv[2]
S = spec['components']['schemas']

# file name -> (struct name, [(method, path, func name)])
GROUPS = {
    'BrandsAPI': [('get', '/api/v1/brands', 'brands'), ('get', '/api/v1/brands/featured', 'featuredBrands'),
                  ('get', '/api/v1/brands/{brandId}', 'brand')],
    'EventsAPI': [('get', '/api/v1/events', 'events'), ('get', '/api/v1/events/{eventId}', 'event')],
    'LegalDocumentsAPI': [('get', '/api/v1/legal-documents/{type}', 'legalDocument'),
                          ('get', '/api/v1/legal-documents/{type}/versions', 'legalDocumentVersions')],
    'AddressesAPI': [('get', '/api/v1/me/addresses', 'addresses'), ('post', '/api/v1/me/addresses', 'createAddress'),
                     ('put', '/api/v1/me/addresses/{addressId}', 'updateAddress'),
                     ('delete', '/api/v1/me/addresses/{addressId}', 'deleteAddress')],
    'ReviewsAPI': [('get', '/api/v1/products/{productId}/reviews', 'reviews'),
                   ('post', '/api/v1/products/{productId}/reviews', 'createReview'),
                   ('get', '/api/v1/products/{productId}/reviews/summary', 'reviewSummary'),
                   ('get', '/api/v1/me/reviewable-items', 'reviewableItems')],
    'ProductQuestionsAPI': [('get', '/api/v1/products/{productId}/questions', 'questions'),
                            ('post', '/api/v1/products/{productId}/questions', 'createQuestion')],
    'DiscoveryAPI': [('get', '/api/v1/products/recommended', 'recommendedProducts'),
                     ('get', '/api/v1/products/{productId}/related', 'relatedProducts'),
                     ('get', '/api/v1/search/recommended-keywords', 'recommendedKeywords'),
                     ('get', '/api/v1/popups', 'popups'), ('get', '/api/v1/company', 'company'),
                     ('get', '/api/v1/checkout/options', 'checkoutOptions')],
    'AccountSettingsAPI': [('get', '/api/v1/me/social-accounts', 'socialAccounts'),
                           ('delete', '/api/v1/me/social-accounts/{provider}', 'disconnectSocialAccount'),
                           ('put', '/api/v1/me/marketing-consent', 'updateMarketingConsent')],
}
EXISTING = set()  # Swift types already defined elsewhere, filled from argv[3:]
for f in sys.argv[3:]:
    EXISTING |= set(re.findall(r'struct (API\w+)', open(f).read()))
# Endpoints whose `data` is omitted when there is nothing to return (verified against the live server).
OPTIONAL_DATA = {'featuredBrands'}
ALIAS = {'ProductSummaryResponse': 'APIProductSummary', 'CertificationResponse': 'APICertification'}
# Spec schemas with generic names, generated under a clearer Swift name.
RENAME = {'Detail': 'APIBrandDetail'}

def ref(x): return x['$ref'].split('/')[-1]
def swift_name(schema): return ALIAS.get(schema) or RENAME.get(schema) or 'API' + schema

needed, order = {}, []
def need(schema):
    if schema in ALIAS or swift_name(schema) in EXISTING or schema in needed: return
    needed[schema] = None; order.append(schema)
    for v in S[schema].get('properties', {}).values(): swift_type(v)

def swift_type(v):
    if '$ref' in v:
        n = ref(v)
        if n.startswith('PageResponse'):
            inner = ref(S[n]['properties']['content']['items']); need(inner)
            return f'APIPage<{swift_name(inner)}>'
        need(n); return swift_name(n)
    t = v.get('type'); fmt = v.get('format')
    if isinstance(t, list): t = [x for x in t if x != 'null'][0]
    if t == 'array': return f'[{swift_type(v["items"])}]'
    if t == 'integer': return 'Int64' if fmt == 'int64' else 'Int'
    if t == 'number': return 'Double'
    if t == 'boolean': return 'Bool'
    if t == 'object': return '[String: String]'
    return 'String'

def lower_first(s): return s[0].lower() + s[1:]

for file, ops in GROUPS.items():
    funcs = []
    for meth, path, fname in ops:
        op = spec['paths'][path][meth]
        res = op['responses'].get('200') or op['responses'].get('201')
        schema = (res.get('content') or {}).get('*/*', (res.get('content') or {}).get('application/json', {})).get('schema', {})
        data = S[ref(schema)]['properties'].get('data', {}) if '$ref' in schema else {}
        payload = swift_type(data) if data and ('$ref' in data or data.get('type')) else 'APIEmptyPayload'
        params, path_expr, query = [], 'api/v1' + path[len('/api/v1'):], []
        for p in op.get('parameters', []):
            if p['in'] == 'header': continue
            name = re.sub(r'Id$', 'ID', p['name']); typ = swift_type(p.get('schema', {}))
            if p['in'] == 'path':
                params.append(f'{name}: {typ}'); path_expr = path_expr.replace('{' + p['name'] + '}', f'\\({name})')
            else:
                params.append(f'{name}: {typ}? = nil'); query.append((p['name'], name, typ))
        body = op.get('requestBody', {}).get('content', {}).get('application/json', {}).get('schema')
        if body: need(ref(body)); params.append(f'body: {swift_name(ref(body))}')
        secured = op.get('security', spec.get('security')) and any(t in (op.get('tags') or [''])[0] for t in ['내 정보', '배송지', '상품 리뷰', '상품 문의']) and (meth != 'get' or '/me/' in path)
        params.append('accessToken: String? = nil')
        summary = (op.get("summary") or "").strip().split('\n')[0][:70]
        lines = [f'    /// {meth.upper()} {path} — {summary}']
        ret = f'{payload}?' if fname in OPTIONAL_DATA else payload
        sig = f'    func {fname}({", ".join(params)}) async throws -> {ret} {{'
        if len(sig) <= 120:
            lines.append(sig)
        else:
            lines.append(f'    func {fname}(')
            lines.append(',\n'.join(f'        {x}' for x in params))
            lines.append(f'    ) async throws -> {ret} {{')
        qi = 'queryItems'
        if query:
            lines.append('        var queryItems: [URLQueryItem] = []')
            for raw, name, typ in query:
                if typ.startswith('['):
                    inner = typ[1:-1]
                    conv = 'value' if inner == 'String' else 'String(value)'
                    lines.append(f'        for value in {name} ?? [] {{ queryItems.append(URLQueryItem(name: "{raw}", value: {conv})) }}')
                    continue
                conv = name if typ == 'String' else f'String({name})'
                lines.append(f'        if let {name} {{ queryItems.append(URLQueryItem(name: "{raw}", value: {conv})) }}')
        args = f'path: "{path_expr}"' + (f', method: .{meth}' if meth != 'get' else '') + (f', queryItems: {qi}' if query else '')
        arg_list = [f'path: "{path_expr}"']
        if body or meth != 'get': arg_list.append(f'method: .{meth}')
        if query: arg_list.append('queryItems: queryItems')
        if body: arg_list.append('body: body')
        arg_list.append('accessToken: accessToken')
        ctor = f'try APIRequest<{payload}>.json' if body else f'APIRequest<{payload}>'
        one = f'        let request = {ctor}({", ".join(arg_list)})'
        if len(one) <= 120:
            lines.append(one)
        else:
            lines.append(f'        let request = {ctor}(')
            lines.append(',\n'.join(f'            {a}' for a in arg_list))
            lines.append('        )')
        if fname in OPTIONAL_DATA:
            lines.append('        return try await client.send(request).data')
        else:
            lines.append('        return try await client.sendData(request)' if payload != 'APIEmptyPayload' else '        _ = try await client.send(request)\n        return APIEmptyPayload()')
        lines.append('    }')
        funcs.append('\n'.join(lines))
    src = f'import Foundation\n\n// Generated from the backend OpenAPI spec (/v3/api-docs). Keep field names in sync with Swagger.\nstruct {file} {{\n    private let client: APIClient\n\n    init(client: APIClient) {{\n        self.client = client\n    }}\n\n' + '\n\n'.join(funcs) + '\n}\n'
    open(f'{out_dir}/{file}.swift', 'w').write(src)

models = ['import Foundation\n\n// Generated from the backend OpenAPI spec (/v3/api-docs). Keep field names in sync with Swagger.']
for schema in order:
    sch = S[schema]; req = set(sch.get('required', []))
    is_request = schema.endswith('Request')
    proto = 'Encodable' if is_request else 'Decodable'
    fields = []
    for k, v in sch.get('properties', {}).items():
        opt = '' if (k in req and not is_request) or (is_request and k in req) else '?'
        fields.append(f'    let {k}: {swift_type(v)}{opt}')
    models.append(f'struct {swift_name(schema)}: {proto} {{\n' + '\n'.join(fields) + '\n}')
open(f'{out_dir}/GeneratedAPIModels.swift', 'w').write('\n\n'.join(models) + '\n')
print('files:', list(GROUPS), 'models:', len(order))
