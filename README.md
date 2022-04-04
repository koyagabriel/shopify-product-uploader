# Shopify Product Uploader
A simple app for uploading products to a shopify store

## Starting the app.
1. Start up your terminal.
2. Ensure that you've `ruby` installed on your machine.
3. Ensure you have Postgresql database installed on your machine.
4. Ensure you have `redis` installed on your machine. For mac os, run `brew install redis`
5. Start the redis service. For mac os run `brew services start redis`.
6. Clone the repository from `git@github.com:koyagabriel/shopify-product-uploader.git`.
7. Run `bundle install` to install necessary gems.
   1. We are using `Figaro gem` to manage our environment variables, so we need to do the following to setup our variables.
      - Run `bundle exec figaro install` to create `config/application.yml` file. This is where we  will add our env variables.
      - Add the following variables to `config/application.yml`. Ensure you set their values.
        ```
          database_name: <the name of your database>
          database_password: <database password>
          database_user: <database user>
          database_host: <database host>
          shopify_api_key: <Your shopify api key>
          shopify_token: <Your shopify token>
          shopify_password: <Your shopify password>
          shopify_shop_name: <Your store name on shopify without the domain. e.g 'latori-test' and not 'latori-test.myshopify.com'>
          ```
8. Run the command `rails db:setup` to setup the database.
9. To start the scheduled background job, run `bundle exec sidekiq`. Note that this is a cron job that runs hourly once started.
10. The background job will then run hourly.
11. To visually see the scheduled jobs, visit the route `/sidekiq` on your browser.

### Note: 
If you need to run the product upload process just once outside of sidekiq, run the rake task command `rake shopify:upload_product`.

### Developer
Koya Adegboyega.