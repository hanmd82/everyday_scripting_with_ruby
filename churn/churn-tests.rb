require 'test/unit'
require_relative 'churn'

class ChurnTests < Test::Unit::TestCase 

  def test_month_before_is_28_days
    assert_equal(Time.local(2005, 1, 1),
                 month_before(Time.local(2005, 1, 29)))
  end

  def test_header_format
    head = header(svn_date(month_before(Time.local(2005, 9, 2))))
    assert_equal("Changes between 2005-08-05 and #{Time.now.strftime('%Y-%m-%d')}:", head)
  end

  def test_normal_subsystem_line_format
    assert_equal('audit           (45 changes)  *********',
                  subsystem_line("audit", 45))
  end

  def test_asterisks_for_divides_by_five
    assert_equal('****', asterisks_for(20))
  end

  def test_asterisks_for_rounds_up_and_down
    assert_equal('****', asterisks_for(18))
    assert_equal('***', asterisks_for(17))
  end

  def test_subversion_log_can_have_no_changes
    assert_equal(0, extract_change_count_from("-----------------------------------\
      --------------------------------------\n"))
  end

  def test_subversion_log_with_changes
    assert_equal(2, extract_change_count_from("-------------------------------------\
---------------------------------------------=---------------\nr2531 | bem | 2005-07-01 01:1\
1:44 -0500 (Fri, 01 Jul 2005) | 1 line\n\nrevisions up through ch 3 exer\
cises\n--------------------------------------------------=----------------------------------------------\
-\nr2524 | bem | 2005-06-30 18:45:59 -0500 (Thu, 30 Jun 2005) | 1 line\n\
\nresults of read-through; including renaming mistyping to snapshots\n---\
----------------------------------------------------------------\n"))
  end

  def test_svn_date
    assert_equal('2005-03-04', svn_date(Time.local(2005, 3, 4)))
  end

  def test_churn_line_to_int_extracts_parenthesized_change_count
    assert_equal(19, churn_line_to_int("    ui2 (19 changes)  ****"))
    assert_equal(9, churn_line_to_int("    ui2 (9 changes)  **"))
    # TODO: test for zero lines
  end
end
