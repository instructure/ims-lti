module IMS::LTI::Models::Messages
  class BasicLTILaunchRequest < IMS::LTI::Models::LTIModel

    add_attributes :context_id, :context_type, :launch_presentation_return_url, :resource_link_id, :role_scope_mentor,
                   :tool_consumer_instance_guid, :user_image

  end
end