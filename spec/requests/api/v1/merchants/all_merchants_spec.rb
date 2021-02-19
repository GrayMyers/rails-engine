describe "Fetch all merchants", type: :request do
  it 'succeeds when there is something to fetch' do
    expected_names = {}
    merchants =  (0..50).map{ |i| expected_names[i] = "merchant #{i}"; Merchant.create(name: "merchant #{i}") }
    # get "/api/v1/items/#{item.id}"
    get api_v1_merchants_path
    expect(response.status).to eq(200)
    json = JSON.parse(response.body, symbolize_names: true)
    (0..19).each do |i|
      expected_hash = {
         id: merchants[i].id.to_s,
         type: "merchant",
         attributes: {name: expected_names[i]}
      }
      expect(json[:data][i]).to eq(expected_hash)
    end
  end
  it 'returns an empty array if data does not exist' do
    get api_v1_merchants_path
    expect(response.status).to eq(200)
    # as an extension, you can make a custom error message, but a 404 with an empty "data" structure from the serializer is fine too
    json = JSON.parse(response.body, symbolize_names: true)
    expect(json).to eq({data: []})
  end
end
