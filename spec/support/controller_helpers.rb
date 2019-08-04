module ControllerHelpers
  def login(user)
    @request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in(user)
  end

  def attach_file_to(receiver)
    receiver.files.attach(io: File.open(Rails.root.join('spec/rails_helper.rb').to_s), filename: 'rails_helper.rb')
  end

  def liked(model, user)
    if model.to_s == 'Answer'
      question = create(:question, user: user)
      create(model.to_s.underscore.to_sym, question: question, user: user)
    else
      create(model.to_s.underscore.to_sym, user: user)
    end
  end
end
