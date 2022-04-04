PASSWORD = Figaro.env.shopify_password
API_KEY = Figaro.env.shopify_api_key
SHOP_NAME = Figaro.env.shopify_shop_name
API_VERSION = Figaro.env.shopify_api_version
TOKEN = Figaro.env.shopify_token
SHOP_URL = "https://#{API_KEY}:#{PASSWORD}@#{SHOP_NAME}.myshopify.com"

ShopifyAPI::Base.site = SHOP_URL
ShopifyAPI::Base.api_version = API_VERSION

