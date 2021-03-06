require './auth'
class AccountIdentityTokenEg < DataSiftExample
  def initialize
    super
    @datasift = DataSift::Client.new(@config)
    run
  end

  def run
    begin
      puts "Create a new identity to create tokens for"
      identity = @datasift.account_identity.create(
        "Ruby Identity for Tokens",
        "active",
        false
      )
      identity_id = identity[:data][:id]
      puts identity.to_json

      puts "\nCreate a Token for our Identity"
      puts @datasift.account_identity_token.create(
        identity_id,
        'facebook',
        'YOUR_TOKEN'
      )

      puts "\nList all existing Tokens for this Identity"
      puts @datasift.account_identity_token.list(
        identity_id
      ).to_json

      puts "\nGet existing Token by Identity and Service"
      puts @datasift.account_identity_token.get(
        identity_id,
        'facebook'
      ).to_json

      puts "\nUpdate a Token for a given Identity"
      puts @datasift.account_identity_token.update(
        identity_id,
        'facebook',
        'YOUR_NEW_TOKEN'
      ).to_json

      puts "\nDelete an Token for a given Identity and Service"
      puts @datasift.account_identity_token.delete(
        identity_id,
        'facebook'
      ).to_json

      puts "\nCleanup and remove the Identity"
      @datasift.account_identity.delete(identity_id)

    rescue DataSiftError => dse
      puts dse.message
      # Then match specific error to take action;
      #   All errors thrown by the client extend DataSiftError
      case dse
        when ConnectionError
          # some connection error
        when AuthError
        when BadRequestError
        else
          # do something else...
      end
    end
  end
end

AccountIdentityTokenEg.new
