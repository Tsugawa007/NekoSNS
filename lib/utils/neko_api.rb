module Utils
    require 'net/http'
    require 'json'
    class NekoApi
      attr_accessor :ans
      def initialize(body)
        uri = URI('https://neko-sns-api.cognitiveservices.azure.com/vision/v3.2/analyze')
        uri.query = URI.encode_www_form({
          # Request parameters
          #'visualFeatures' => 'Categories,Adult',
          'visualFeatures' => 'Description,Adult',
          'language' => 'ja'
        })
        request = Net::HTTP::Post.new(uri.request_uri)
        # Request headers
        request['Content-Type'] = 'application/octet-stream'
        # Request headers
        request['Ocp-Apim-Subscription-Key'] = 'ffa7f0e47f954f56a0127f7322e902fe'
        request.body = body
        response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
          http.request(request)
        end
        #self.ans = return_ans(response.body)
        self.ans = return_ans(response.body)
      end
      
      def return_ans(res)
        hash = JSON.parse(res)
        Rails.logger.debug "log : #{hash.inspect}" 
        if hash["description"]["tags"].find { |item| item == '猫' } != nil
          if hash["adult"]["isAdultContent"] | hash["adult"]["isRacyContent"] | hash["adult"]["isGoryContent"]  == false
            return 0
            #いいね
          else
            return 1
            #"不適切な写真です"
          end
        else
          return 2
          #"写真の中に猫がいません"
        end
      end
    end
  end