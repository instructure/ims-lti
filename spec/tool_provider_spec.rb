require "spec_helper"
describe IMS::LTI::ToolProvider do
  #todo test stuff from certification: http://www.imsglobal.org/developers/alliance/LTI/cert-v1p1/
  before do
    create_test_tp
  end

  it "should recognize an outcome service" do
    @tp.outcome_service?.should == true
    @tp.lis_result_sourcedid = nil
    @tp.outcome_service?.should == false
  end

  it "should generate a return url with messages" do
    @tp.build_return_url.should == @params['launch_presentation_return_url']
    @tp.lti_errormsg = "user error message"
    @tp.lti_errorlog = "lms error log"
    @tp.lti_msg = "user message"
    @tp.lti_log = "lms message"
    @tp.build_return_url.should == @params['launch_presentation_return_url'] + "?lti_errormsg=user%20error%20message&lti_errorlog=lms%20error%20log&lti_msg=user%20message&lti_log=lms%20message"
  end

  it "should find the base role" do
    @tp.roles = "urn:lti:role:ims/lis/Instructor/GuestInstructor"
    @tp.has_base_role?("urn:lti:role:ims/lis/Instructor").should == true
    @tp.has_exact_role?("urn:lti:role:ims/lis/Instructor").should == false
  end

  it "should recognize the learner roles" do
    @tp.roles = "urn:lti:instrole:ims/lis/Student"
    @tp.institution_student?.should == true
    @tp.context_student?.should == false
    @tp.roles = "Learner"
    @tp.institution_student?.should == false
    @tp.context_student?.should == true
    @tp.roles = "urn:lti:role:ims/lis/Learner"
    @tp.institution_student?.should == false
    @tp.context_student?.should == true
  end

  it "should recognize the instructor roles" do
    @tp.roles = "urn:lti:instrole:ims/lis/Instructor"
    @tp.institution_instructor?.should == true
    @tp.context_instructor?.should == false
    @tp.roles = "Instructor"
    @tp.institution_instructor?.should == false
    @tp.context_instructor?.should == true
    @tp.roles = "urn:lti:role:ims/lis/Instructor"
    @tp.institution_instructor?.should == false
    @tp.context_instructor?.should == true
    @tp.roles = "urn:lti:role:ims/lis/Instructor/GuestInstructor"
    @tp.institution_instructor?.should == false
    @tp.context_instructor?.should == false
  end

  it "should recognize the admin roles" do
    @tp.roles = "urn:lti:instrole:ims/lis/Administrator"
    @tp.institution_admin?.should == true
    @tp.context_admin?.should == false
    @tp.roles = "Administrator"
    @tp.institution_admin?.should == false
    @tp.context_admin?.should == true
    @tp.roles = "urn:lti:role:ims/lis/Administrator"
    @tp.institution_admin?.should == false
    @tp.context_admin?.should == true
    @tp.roles = "urn:lti:role:ims/lis/Administrator/ExternalSystemAdministrator"
    @tp.institution_admin?.should == false
    @tp.context_admin?.should == false
  end

  it "should recognize other context roles" do
    @tp.roles = "Mentor,TeachingAssistant,ContentDeveloper"
    @tp.context_content_developer?.should == true
    @tp.context_mentor? == true
    @tp.context_ta? == true
    @tp.roles = "urn:lti:role:ims/lis/Mentor,urn:lti:role:ims/lis/TeachingAssistant,urn:lti:role:ims/lis/ContentDeveloper"
    @tp.context_content_developer?.should == true
    @tp.context_mentor? == true
    @tp.context_ta? == true
  end

  it "should recognize the deprecated roles" do
    @tp.student?.should == true
    @tp.instructor?.should == true
    @tp.content_developer?.should == false
    @tp.member?.should == true
    @tp.manager?.should == false
    @tp.mentor?.should == true
    @tp.admin?.should == true
    @tp.ta?.should == true
    @tp.has_role?('Observer').should == true
    @tp.has_role?('someDude').should == false
  end

  it "should find the best username" do
    @tp.username("guy").should == "guy"
    @tp.lis_person_name_full = "full"
    @tp.username("guy").should == "full"
    @tp.lis_person_name_family = "family"
    @tp.username("guy").should == "family"
    @tp.lis_person_name_given = "given"
    @tp.username("guy").should == "given"
  end

end
