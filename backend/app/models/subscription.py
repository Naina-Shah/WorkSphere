from datetime import date
from decimal import Decimal

from sqlalchemy import CheckConstraint

from sqlalchemy import Date, ForeignKey, Numeric, String
from sqlalchemy.orm import Mapped, mapped_column, relationship

from backend.app.database import Base


class Subscription(Base):
    __tablename__ = "subscriptions"

    __table_args__ = (
        CheckConstraint(
            "end_date >= start_date",
            name="ck_subscription_dates"
        ),
        CheckConstraint(
            "price >= 0",
            name="ck_subscription_price"
        ),
    )

    subscription_id: Mapped[int] = mapped_column(primary_key=True)

    project_id: Mapped[int] = mapped_column(
        ForeignKey("projects.project_id", ondelete="CASCADE"),
        nullable=False
    )
    plan_id: Mapped[int] = mapped_column(
        ForeignKey("subscription_plans.plan_id", ondelete="RESTRICT"),
        nullable=False
    )

    start_date: Mapped[date] = mapped_column(Date, nullable=False)
    end_date: Mapped[date] = mapped_column(Date, nullable=False)
    price: Mapped[Decimal] = mapped_column(Numeric(10, 2), nullable=False)

    status: Mapped[str] = mapped_column(
        String(20), default="active", nullable=False
    )

    project = relationship("Project", back_populates="subscriptions")
    plan = relationship("SubscriptionPlan", back_populates="subscriptions")

    invoices = relationship(
        "Invoice",
        back_populates="subscription",
        cascade="all, delete-orphan"
    )

