shared_examples_for 'API links' do
  context 'links' do
    let(:link) { links.last }
    let(:links_response) { object_response['links'] }
    let(:link_response) { links_response.first }

    it 'rerurn list of links' do
      expect(links_response.size).to eq links.size
    end

    it 'returns all public fields' do
      %w[id name url created_at updated_at].each do |attr|
        expect(link_response[attr]).to eq link.send(attr).as_json
      end
    end
  end
end