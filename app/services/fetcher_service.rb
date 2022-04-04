class FetcherService

  class << self

    def fetch_products_from_cdn(file_url)
      # Fetches product json file  to upload from cdn.
      # It returns a list of products or an empty list if
      # an error occurs.

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