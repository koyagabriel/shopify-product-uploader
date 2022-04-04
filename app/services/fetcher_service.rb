class FetcherService

  class << self

    def fetch_products_from_cdn(file_url)
      begin
        response =  RestClient.get(file_url)
        JSON.parse(response.body)
      rescue RestClient::ExceptionWithResponse
        print("An error occurred while trying to fetch product.json file")
        []
      end

    end
  end
end