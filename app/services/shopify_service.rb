class ShopifyService
  attr_reader :product_list, :file_url, :product_attributes,
    :variant_attributes, :image_attributes, :product

  def initialize(file_url)
    @file_url = file_url
  end

  def upload_products
    get_product_list

    if product_list.present?
      product_list.each { |prod| process_product_upload(prod.with_indifferent_access.dig(*%i[data resource])) }
    end
    puts("#{'=====' * 10} \n Done \n #{'=====' * 10}")
  end

  private

    def get_product_list
      @product_list = FetcherService.fetch_products_from_cdn(file_url)
    end

    def process_product_upload(resource)
      status = resource[:status]&.downcase
      separate_resource_attributes(resource)
      @product = ProductService.find_product_in_shopify_by_sku(variant_attributes[:sku])

      case status
      when "active", "inactive"
        process_product_with_active_or_inactive_status
      when "deleted"
        process_product_with_delete_status
      else
        puts("Unrecognized product status ")
      end
    end

    def process_product_with_active_or_inactive_status
      unless product.present?
        ProductService.create_product_in_shopify(product_attributes, variant_attributes, image_attributes)
      else
        ProductService.update_product_in_shopify(product, product_attributes, variant_attributes, image_attributes) if product_data_changed?
      end
    end

    def process_product_with_delete_status
      ProductService.delete_product_from_shopify(product) if product.present?
    end

    def separate_resource_attributes(resource)
      @product_attributes = {
        body_html: resource["description"],
        title: resource["title"],
        status: resource["status"] == "inactive" ? "draft" : resource["status"],
        tags: resource["tags"]
      }
      @variant_attributes = {
        price: resource["price"],
        sku: resource["ItemNumber"],
        inventory_quantity: resource["quantity"]
      }
      @image_attributes = resource["images"].map { |img| { src: img["link"] } }
    end

    def product_data_changed?
      attributes = product.as_json
      variant_attr = product.variants.first.as_json
      image_attr = product.images.as_json

      old_product_attributes = {
        body_html: attributes["body_html"],
        title: attributes["title"],
        status: attributes["status"],
        tags: attributes["tags"]
      }

      old_variant_attributes = {
        price: variant_attr["price"],
        sku: variant_attr["sku"],
        inventory_quantity: variant_attr["inventory_quantity"]
      }

      old_image_attributes = image_attr.map { |img| {src: img["src"]} }

      (product_attributes != old_product_attributes) || (variant_attributes != old_variant_attributes) || (image_attributes != old_image_attributes)
    end


end
