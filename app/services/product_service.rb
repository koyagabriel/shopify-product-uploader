class ProductService

  class << self

    def find_product_in_shopify_by_sku(sku)
      # Fetches product from shopify using the
      # sku of a variant.
      ShopifyAPI::Product.all.find do |prod|
        prod.variants.find { |var| var.sku == sku }
      end
    end

    def delete_product_from_shopify(product)
      # Deletes product from shopify store using product id only
      # if the product exists

      ShopifyAPI::Product.delete(product.id) if product.present?
      puts("Successfully deleted product #{product.title} \n\n")

    rescue StandardError
      puts("An error occurred while trying to delete product #{product.title} \n\n")
    end

    def create_product_in_shopify(product_attr, variant_attr, image_attr)
      # Creates a new product in shopify store. It also creates a variant
      # and images for the product

      # merging the product attributes, variant attributes and image attributes, so that
      # they can be passed together as params when making the api call to shopify.
      merged_attributes = ProductService.merge_attributes(product_attr, variant_attr, image_attr)
      puts("Creating with a new product with the attributes \n #{merged_attributes} \n\n")
      new_product = ShopifyAPI::Product.new(merged_attributes)
      new_product.save!
      puts("Successfully created Product with title #{new_product.title}\n\n")
      new_product

    rescue StandardError
      puts("An error occurred while trying to create Product #{new_product.title} \n\n")
    end

    def update_product_in_shopify(product_instance, product_attr, variant_attr, image_attr)
      # Updates an existing product in shopify store. It also updates the variant
      # and images of the product if needed.

      # merging the product attributes, variant attributes and image attributes, so that
      # they can be passed together as params when making the api call to shopify.
      merged_attributes = ProductService.merge_attributes(product_attr, variant_attr, image_attr)
      puts("Updating product #{product_instance.title} with \n #{merged_attributes} \n\n")
      product_instance.update_attributes(merged_attributes)
      puts("Successfully updated Product #{product_instance.title} \n\n")

    rescue ActiveResource::ServerError
      # No sure why shopify returns bad gateway, even though the product was successfully updated.
      # It seems to happen when updating 'inventory_quantity'
      if product_instance.persisted?
        puts("Successfully updated product #{product_instance.title} \n\n")
      else
        puts("An error occurred while trying to update product #{product_instance.title} \n\n")
      end

    rescue StandardError
      puts("An error occurred while trying to update product #{product_instance.title} \n\n")
    end

    def merge_attributes(product_attr, variant_attr, image_attr)
      # Helper method for combining the product attributes, variant attributes and
      # image attributes into a single hash

      product_attr.merge({variants: [variant_attr], images: image_attr})
    end
  end

end
