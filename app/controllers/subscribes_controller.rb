# frozen_string_literal: true

class SubscribesController < ApplicationController
  layout "user_subscribe"

  def index
    @hello_world_props = { name: "Stranger" }
  end
end
