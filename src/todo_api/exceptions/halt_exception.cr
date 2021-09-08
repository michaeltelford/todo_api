class HaltException < Exception
  DEFAULT_MESSAGE = "A HTTP Handler was deliberately halted. If you're seeing this message in development it's probably because your handler is missing a `rescue HaltException... context... end` block."

  def initialize(message = DEFAULT_MESSAGE)
    super
  end
end
