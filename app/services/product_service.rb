class ProductService

  class << self

    def find_product_in_shopify_by_sku(sku)
      ShopifyAPI::Product.all.find do |prod|
        prod.variants.find { |var| var.sku == sku }
      end
    end

    def delete_product_from_shopify(product)
      ShopifyAPI::Product.delete(product.id) if product.present?
      puts("Successfully deleted Product #{product.title}")
    rescue StandardError
      puts("An error occurred while trying to delete Product #{product.title}")
    end

    def create_product_in_shopify(product_attr, variant_attr, image_attr)
      merged_attribute = ProductService.merge_attributes(product_attr, variant_attr, image_attr)
      new_product = ShopifyAPI::Product.new(merged_attribute)
      new_product.save!
      puts("Successfully created Product #{new_product.id}")
      new_product
    rescue StandardError
      puts("An error occurred while trying to create Product #{new_product.title}")
    end

    def update_product_in_shopify(product_instance, product_attr, variant_attr, image_attr)
      variant_attr.delete(:inventory_quantity)
      merged_attributes = ProductService.merge_attributes(product_attr, variant_attr, image_attr)
      product_instance.update_attributes(merged_attributes)
    rescue StandardError
      puts("An error occurred while trying to update Product #{product_instance.title}")
    end

    def merge_attributes(product_attr, variant_attr, image_attr)
      product_attr.merge({variants: [variant_attr], images: image_attr})
    end
  end

end
