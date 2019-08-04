FactoryBot.define do
  factory :link do
    name { "MyString" }
    url { "https://google.com" }
  end

  trait :gist_link do
    name { "Gist" }
    url { "https://gist.github.com/eugeneshumilin/9396d814f0cfd5510ae9ce091a1e9069" }
  end
end
