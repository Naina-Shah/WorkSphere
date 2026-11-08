from datetime import date
from decimal import Decimal
from sqlalchemy import CheckConstraint
from sqlalchemy import Date, ForeignKey, Numeric, String
from sqlalchemy.orm import Mapped, mapped_column, relationship

from backend.app.database import Base


class Invoice(Base):
    __tablename__ = "invoices"

    __table_args__ = (
        CheckConstraint("amount >= 0", name="ck_invoice_amount"),
        CheckConstraint("due_date >= issue_date", name="ck_invoice_dates"),
    )

    invoice_id: Mapped[int] = mapped_column(primary_key=True)

    subscription_id: Mapped[int] = mapped_column(
        ForeignKey("subscriptions.subscription_id", ondelete="RESTRICT"),
        nullable=False
    )

    amount: Mapped[Decimal] = mapped_column(Numeric(10, 2), nullable=False)
    issue_date: Mapped[date] = mapped_column(Date, nullable=False)
    due_date: Mapped[date] = mapped_column(Date, nullable=False)

    status: Mapped[str] = mapped_column(
        String(20), default="unpaid", nullable=False
    )

    subscription = relationship("Subscription", back_populates="invoices")

    payments = relationship(
        "Payment",
        back_populates="invoice",
        cascade="all, delete-orphan"
    )
