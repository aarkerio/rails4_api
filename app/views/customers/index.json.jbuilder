json.array!(@customers) do |customer|
  json.extract! customer, :id, :name, :apy_key, :secret_key, :active
  json.url customer_url(customer, format: :json)
end
