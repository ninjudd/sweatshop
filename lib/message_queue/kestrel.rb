module MessageQueue
  class Kestrel < Base
    def initialize(opts)
      @servers = opts['servers']
    end

    def queue_size(queue)
      size  = 0
      stats = client.stats
      servers.each do |server|
        size += stats[server]["queue_#{queue}_items"].to_i
      end
      size
    end

    def enqueue(queue, data)
      client.set(queue, data)
    end

    def dequeue(queue)
      client.get("#{queue}/open")
    end

    def confirm(queue)
      client.get("#{queue}/close")
    end

    def client
      @client ||= MemCache.new(servers) 
    end
  end
end
