shared_examples_for 'API comments' do
  context 'comments' do
    let(:comment) { comments.last }
    let(:comments_response) { object_response['comments'] }
    let(:comment_response) { comments_response.first }

    it 'rerurn list of comments' do
      expect(comments_response.size).to eq comments.size
    end

    it 'returns all public fields' do
      %w[id body created_at updated_at].each do |attr|
        expect(comment_response[attr]).to eq comment.send(attr).as_json
      end
    end
  end
end