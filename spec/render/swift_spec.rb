require_relative '../spec_helper'
require_relative "../render_shared"

describe 'Render as swift' do
  include_context "shared render"

  before(:each) do
    # In Hiptest: null
    @null_rendered = 'nil'

    # In Hiptest: 'What is your quest ?'
    @what_is_your_quest_rendered = '"What is your quest ?"'

    # In Hiptest: 3.14
    @pi_rendered = '3.14'

    # In Hiptest: false
    @false_rendered = 'false'

    # In Hiptest: "${foo}fighters"
    @foo_template_rendered = '"\(foo)fighters"'

    # In Hiptest: "Fighters said \"Foo !\""
    @double_quotes_template_rendered = '"Fighters said \"Foo !\""'

    # In Hiptest: ""
    @empty_template_rendered = '""'

    # In Hiptest: foo (as in 'foo := 1')
    @foo_variable_rendered = 'foo'
    @foo_bar_variable_rendered = 'fooBar'

    # In Hiptest: foo.fighters
    @foo_dot_fighters_rendered = 'foo.fighters'

    # In Hiptest: foo['fighters']
    @foo_brackets_fighters_rendered = 'foo["fighters"]!'

    # In Hiptest: -foo
    @minus_foo_rendered = '-foo'

    # In Hiptest: foo - 'fighters'
    @foo_minus_fighters_rendered = 'foo - "fighters"'

    # In Hiptest: (foo)
    @parenthesis_foo_rendered = '(foo)'

    # In Hiptest: [foo, 'fighters']
    @foo_list_rendered = "[foo, 'fighters']"

    # In Hiptest: foo: 'fighters'
    #TODO - what is property in Swift?
    @foo_fighters_prop_rendered = "foo: 'fighters'"

    # In Hiptest: {foo: 'fighters', Alt: J}
    #TODO - what is dictionary in Swift and how is it different from 'foo["fighters]"'?
    @foo_dict_rendered = "{foo: 'fighters', Alt: J}"

    # In Hiptest: foo := 'fighters'
    @assign_fighters_to_foo_rendered = 'foo = "fighters"'

    # In Hiptest: call 'foo'
    @call_foo_rendered = "actionwords.foo()"
    # In Hiptest: call 'foo bar'
    @call_foo_bar_rendered = "actionwords.fooBar()"

    # In Hiptest: call 'foo'('fighters')
    @call_foo_with_fighters_rendered = 'actionwords.foo("fighters")'
    # In Hiptest: call 'foo bar'('fighters')
    @call_foo_bar_with_fighters_rendered = 'actionwords.fooBar("fighters")'

    # In Hiptest: step {action: "${foo}fighters"}
    @action_foo_fighters_rendered = '// TODO: Implement action: "\(foo)fighters"'
    @call_with_special_characters_in_value_rendered = "actionwords.myCallWithWeirdArguments(\"{\\n  this: 'is',\\n  some: ['JSON', 'outputed'],\\n  as: 'a string'\\n}\")"

    # In Hiptest:
    # if (true)
    #   foo := 'fighters'
    #end
    @if_then_rendered = [
        "if (true) {",
        "  foo = \"fighters\"",
        "}"
      ].join("\n")

    # In Hiptest:
    # if (true)
    #   foo := 'fighters'
    # else
    #   fighters := 'foo'
    #end
    @if_then_else_rendered = [
        "if (true) {",
        "  foo = 'fighters'",
        "}",
        "else {",
        "  fighters = 'foo'",
        "}"
      ].join("\n")

    # In Hiptest:
    # while (foo)
    #   fighters := 'foo'
    #   foo('fighters')
    # end
    @while_loop_rendered = [
        "while (foo) {",
        '  fighters = "foo"',
        '  actionwords.foo("fighters")',
        "}"
      ].join("\n")

    # In Hiptest: @myTag
    @simple_tag_rendered = 'myTag'

    # In Hiptest: @myTag:somevalue
    @valued_tag_rendered = 'myTag:somevalue'

    # In Hiptest: plic (as in: definition 'foo'(plic))
    @plic_param_rendered = 'var plic:String'

    # In Hiptest: plic = 'ploc' (as in: definition 'foo'(plic = 'ploc'))
    # TODO - Made by java sample, maybe we can change it?
    @plic_param_default_ploc_rendered = "var plic:String"

    # In Hiptest:
    # actionword 'my action word' do
    # end
    @empty_action_word_rendered = "func myActionWord(){}"

    # In Hiptest:
    # @myTag @myTag:somevalue
    # actionword 'my action word' do
    # end
    @tagged_action_word_rendered = [
      "func myActionWord() {",
      "  // Tags: myTag myTag:somevalue",
      "}"].join("\n")

    @described_action_word_rendered = [
      "func myActionWord() {",
      "    // Some description",
      "}"].join("\n")

    # In Hiptest:
    # actionword 'my action word' (plic, flip = 'flap') do
    # end
    @parameterized_action_word_rendered = [
      "func myActionWord(_ plic:String, _ flip:String){",
      "}"].join("\n")

    # In Hiptest:
    # @myTag
    # actionword 'compare to pi' (x) do
    #   foo := 3.14
    #   if (foo > x)
    #     step {result: "x is greater than Pi"}
    #   else
    #     step {result: "x is lower than Pi
    #       on two lines"}
    #   end
    # end
    @full_actionword_rendered = [
      "func compareToPi(_ x:String)",
      "  // Tags: myTag",
      "  foo  = 3.14",
      "  if (foo > x){",
      "    // TODO: Implement result: x is greater than Pi",
      " } "
      "  else {",
      "    // TODO: Implement result: x is lower than Pi",
      "    // on two lines",
      "  }",
      "}"].join("\n")

    # In Hiptest:
    # actionword 'my action word' do
    #   step {action: "basic action"}
    # end
    @step_action_word_rendered = [
      "func myActionWord(){",
      "  // TODO: Implement action: basic action",
      "}"].join("\n")

    # In Hiptest, correspond to two action words:
    # actionword 'first action word' do
    # end
    # actionword 'second action word' do
    #   call 'first action word'
    # end
    @actionwords_rendered = [
      "class Actionwords {",
      "  func firstActionWord(){",
      "  }",
      "  func secondActionWord(){",
      "    firstActionWord()",
      "  }",
      "}"].join("\n")

    # In Hiptest, correspond to these action words with parameters:
    # actionword 'aw with int param'(x) do end
    # actionword 'aw with float param'(x) do end
    # actionword 'aw with boolean param'(x) do end
    # actionword 'aw with null param'(x) do end
    # actionword 'aw with string param'(x) do end
    #
    # but called by this scenario
    # scenario 'many calls scenarios' do
    #   call 'aw with int param'(x = 3)
    #   call 'aw with float param'(x = 4.2)
    #   call 'aw with boolean param'(x = true)
    #   call 'aw with null param'(x = null)
    #   call 'aw with string param'(x = 'toto')
    #   call 'aw with template param'(x = "toto")
    @actionwords_with_params_rendered = [
      "class Actionwords {",
      "  func awWithIntParam(x:Int){",
      "  }",
      "",
      "  func awWithFloatParam(x:Float){",
      "  }",
      "",
      "  func awWithBooleanParam(x:Bool){",
      "  }",
      "",
      "  func awWithNullParam(x:String){",
      "  }",
      "",
      "  func awWithStringParam(x:String){",
      "  }",
      "",
      "  func awWithTemplateParam(x:String){",
      "  }",
      "}"
    ].join("\n")
   


    # In Hiptest:
    # @myTag
    # scenario 'compare to pi' (x) do
    #   foo := 3.14
    #   if (foo > x)
    #     step {result: "x is greater than Pi"}
    #   else
    #     step {result: "x is lower than Pi
    #       on two lines"}
    #   end
    # end
    @full_scenario_rendered = [
        "// This is a scenario which description ",
        "// is on two lines",
        "// Tags: myTag",
        "func testCompareToPi() {",
        "    foo = 3.14",
        "    if (foo > x) {",
        "        // TODO: Implement result: x is greater than Pi",
        "    } else {",
        "        // TODO: Implement result: x is lower than Pi",
        "        // on two lines",
        "    }",
        "}"].join("\n")

      @full_scenario_with_uid_rendered = [
        "// This is a scenario which description ",
        "// is on two lines",
        "// Tags: myTag",
        "func testCompareToPiUidabcd1234() {",
        "    foo = 3.14",
        "    if (foo > x) {",
        "        // TODO: Implement result: x is greater than Pi",
        "    } else {",
        "        // TODO: Implement result: x is lower than Pi",
        "        // on two lines",
        "    }",
        "}"].join("\n")

       @full_scenario_rendered_for_single_file = [
        "import XCTest",
        "",
        "class CompareToPiTest:XCTestCase {",
        "",
        "    let actionwords:Actionwords = Actionwords()",
        "",
        "    // This is a scenario which description ",
        "    // is on two lines",
        "    // Tags: myTag",
        "    func testCompareToPi() {",
        "        foo = 3.14",
        "        if (foo > x) {",
        "            // TODO: Implement result: x is greater than Pi",
        "        } else {",
        "            // TODO: Implement result: x is lower than Pi",
        "            // on two lines",
        "        }",
        "    }",
        "}"].join("\n")

    # Same than previous scenario, except that is is rendered
    # so it can be used in a single file (using the --split-scenarios option)
  

    # Scenario definition is:
    # call 'fill login' (login = login)
    # call 'fill password' (password = password)
    # call 'press enter'
    # call 'assert "error" is displayed' (error = expected)

    # Scenario datatable is:
    # Dataset name             | login   | password | expected
    # -----------------------------------------------------------------------------
    # Wrong 'login'            | invalid | invalid  | 'Invalid username or password
    # Wrong "password"         | valid   | invalid  | 'Invalid username or password
    # Valid 'login'/"password" | valid   | valid    | nil

      @scenario_with_datatable_rendered = [
        "func checkLogin(_ login:String, _ password:String, _ expected:String) {",
        "    // Ensure the login process",
        "    actionwords.fillLogin(login)",
        "    actionwords.fillPassword(password)",
        "    actionwords.pressEnter()",
        "    actionwords.assertErrorIsDisplayed(expected)",
        "}",
        "",
        "func testCheckLoginWrongLogin() {",
        '    checkLogin("invalid", "invalid", "Invalid username or password")',
        "}",
        "",
        "func testCheckLoginWrongPassword() {",
        '    checkLogin("valid", "invalid", "Invalid username or password")',
        "}",
        "",
        "func testCheckLoginValidLoginpassword() {",
        '    checkLogin("valid", "valid", null)',
        "}",
        "",
        ""
       ].join("\n")

       @scenario_with_datatable_rendered_with_uids = [
        "func checkLogin(_ login:String, _ password:String, _ expected:String) {",
        "    // Ensure the login process",
        "    actionwords.fillLogin(login)",
        "    actionwords.fillPassword(password)",
        "    actionwords.pressEnter()",
        "    actionwords.assertErrorIsDisplayed(expected)",
        "}",
        "",
        "func testCheckLoginWrongLoginUida123() {",
        '    checkLogin("invalid", "invalid", "Invalid username or password")',
        "}",
        "",
        "func testCheckLoginWrongPasswordUidb456() {",
        '    checkLogin("valid", "invalid", "Invalid username or password")',
        "}",
        "",
        "func testCheckLoginValidLoginpasswordUidc789() {",
        '    checkLogin("valid", "valid", null)',
        "}",
        ""
      ].join("\n")


      # Same than "scenario_with_datatable_rendered" but rendered with the option --split-scenarios
      @scenario_with_datatable_rendered_in_single_file = [
        "import XCTest",
        "",
        "class CheckLoginTest:XCTestCase {",
        "",
        "    let actionwords:Actionwords = Actionwords()",
        "",
        "    func checkLogin(_ login:String, _ password:String, _ expected:String) {",
        "        // Ensure the login process",
        "        actionwords.fillLogin(login)",
        "        actionwords.fillPassword(password)",
        "        actionwords.pressEnter()",
        "        actionwords.assertErrorIsDisplayed(expected)",
        "    }",
        "",
        "    func testCheckLoginWrongLogin() {",
        '        checkLogin("invalid", "invalid", "Invalid username or password")',
        "    }",
        "",
        "    func testCheckLoginWrongPassword() {",
        '        checkLogin("valid", "invalid", "Invalid username or password")',
        "    }",
        "",
        "    func testCheckLoginValidLoginpassword() {",
        '        checkLogin("valid", "valid", null)',
        "    }",
        "}"
      ].join("\n")


    # In Hiptest, correspond to two scenarios in a project called 'My project'
    # scenario 'first scenario' do
    # end
    # scenario 'second scenario' do
    #   call 'my action word'
    # end
     @scenarios_rendered = [
       "import XCTest",
       "",
       "class ProjectTest:XCTestCase {",
       "",
       "    let actionwords:Actionwords = Actionwords()",
       "",
       "    func testFirstScenario() {",
       "    }",
       "",
       "    func testSecondScenario() {",
       "        actionwords.myActionWord()",
       "    }",
       "}"].join("\n")
     
      
      @tests_rendered = [
        'import XCTest',
        '',
        'class ProjectTest: XCTestCase {',
        '',
        '    let actionwords:Actionwords = Actionwords()',
        '    // The description is on ',
        '    // two lines',
        '    // Tags: myTag myTag:somevalue',
        '    func testLogin() {',
        '        actionwords.visit("/login")',
        '        actionwords.fill("user@example.com")',
        '        actionwords.fill("s3cret")',
        '        actionwords.click(".login-form input[type=submit]")',
        '        actionwords.checkUrl("/welcome")',
        '    }',
        '    // ',
        '    // Tags: myTag:somevalue',
        '    func testFailedLogin() {',
        '        actionwords.visit("/login")',
        '        actionwords.fill("user@example.com")',
        '        actionwords.fill("notTh4tS3cret")',
        '        actionwords.click(".login-form input[type=submit]")',
        '        actionwords.checkUrl("/login")',
        '    }',
        '}'
      ].join("\n")

      @first_test_rendered = [
        '// The description is on ',
        '// two lines',
        '// Tags: myTag myTag:somevalue',
        'func testLogin() {',
        '    actionwords.visit("/login")',
        '    actionwords.fill("user@example.com")',
        '    actionwords.fill("s3cret")',
        '    actionwords.click(".login-form input[type=submit]")',
        '    actionwords.checkUrl("/welcome")',
        '}'
      ].join("\n")

      @first_test_rendered_for_single_file = [
        'import XCTest',
        '',
        'class LoginTest: XCTestCase {',
        '',
        '    let actionwords:Actionwords = Actionwords()',
        '',
        '    // The description is on ',
        '    // two lines',
        '    // Tags: myTag myTag:somevalue',
        '    func testLogin() {',
        '        actionwords.visit("/login")',
        '        actionwords.fill("user@example.com")',
        '        actionwords.fill("s3cret")',
        '        actionwords.click(".login-form input[type=submit]")',
        '        actionwords.checkUrl("/welcome")',
        '    }',
        '}'
      ].join("\n")


    # In hiptest
    # scenario 'reset password' do
    #   call given 'Page "url" is opened'(url='/login')
    #   call when 'I click on "link"'(link='Reset password')
    #   call then 'page "url" should be opened'(url='/reset-password')
    # end
     @bdd_scenario_rendered = [
         '',
         'func testResetPassword() {',
         '    // Given Page "/login" is opened',
         '    actionwords.pageUrlIsOpened("/login")',
         '    // When I click on "Reset password"',
         '    actionwords.iClickOnLink("Reset password")',
         '    // Then Page "/reset-password" should be opened',
         '    actionwords.pageUrlShouldBeOpened("/reset-password")',
         '}'
     ].join("\n")
      


  context 'xcuitest' do
    it_behaves_like "a renderer" do
      let(:language) {'swift'}
      let(:framework) {'xcuitest'}
    end
  end
end
