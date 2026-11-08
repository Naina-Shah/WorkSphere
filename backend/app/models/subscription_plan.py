from sqlalchemy import String, Text, Numeric
from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy import CheckConstraint
from backend.app.database import Base


class SubscriptionPlan(Base):
    __tablename__ = "subscription_plans"
    __table_args__ = (
        CheckConstraint("price >= 0", name="ck_plan_price"),
        CheckConstraint(
            "billing_cycle IN ('monthly', 'yearly')",
            name="ck_plan_billing_cycle"
        ),
    )

    plan_id: Mapped[int] = mapped_column(primary_key=True)
    sub_name: Mapped[str] = mapped_column(String(100), unique=True, nullable=False)
    sub_description: Mapped[str | None] = mapped_column(Text, nullable=True)
    sub_price: Mapped[float] = mapped_column(Numeric(10, 2), nullable=False)
    sub_billing_cycle: Mapped[str] = mapped_column(
        String(20), default="monthly", nullable=False
    )
    subscriptions = relationship(
    "Subscription",
    back_populates="plan"
)