if Rails.env.production?
    Rack::Attack.blocklist('block admin identified IPs') do |req|
      should_ban = nil

      BannedIp.all.each do |banned_ip|
        if (banned_ip.ip_address == req.ip)
          should_ban = 1
        end
      end

      should_ban
    end

    Rack::Attack.blocklist('block bad UA') do |req|
      req.user_agent == 'SemrushBot'
    end

    Rack::Attack.throttle('req/ip', :limit => 100, :period => 10.seconds) do |req|
      req.ip
    end
end
