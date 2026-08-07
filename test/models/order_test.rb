require "test_helper"

class OrderTest < ActiveSupport::TestCase
  test "mark_as_paid updates the payment information" do
    order = orders(:manitoba_order)

    order.mark_as_paid!(
      payment_intent_id: "pi_test_success"
    )

    order.reload

    assert_equal "paid", order.status
    assert_equal "pi_test_success",
                 order.stripe_payment_intent_id
    assert_not_nil order.paid_at
  end

  test "mark_as_paid is idempotent for the same payment" do
    order = orders(:manitoba_order)

    order.mark_as_paid!(
      payment_intent_id: "pi_test_success"
    )

    original_paid_at = order.reload.paid_at

    order.mark_as_paid!(
      payment_intent_id: "pi_test_success"
    )

    assert_equal original_paid_at,
                 order.reload.paid_at
  end
end
