from datetime import datetime

from sqlalchemy import (
    DateTime,
    ForeignKey,
    String,
    func,
)
from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy import CheckConstraint
from backend.app.database import Base


class CompanyUser(Base):
    __tablename__ = "company_users"

    __table_args__ = (
    CheckConstraint(
        "role IN ('owner', 'admin', 'member')",
        name="ck_company_user_role"
    ),
    CheckConstraint(
        "status IN ('active', 'inactive', 'invited')",
        name="ck_company_user_status"
    ),
)

    company_id: Mapped[int] = mapped_column(
        ForeignKey("companies.company_id", ondelete="CASCADE"),
        primary_key=True
    )

    user_id: Mapped[int] = mapped_column(
        ForeignKey("users.user_id", ondelete="CASCADE"),
        primary_key=True
    )

    role: Mapped[str] = mapped_column(
        String(50),
        nullable=False,
        default="member"
    )

    status: Mapped[str] = mapped_column(
        String(20),
        nullable=False,
        default="active"
    )

    joined_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        server_default=func.now(),
        nullable=False
    )

    company = relationship("Company", back_populates="memberships")
    user = relationship("User", back_populates="company_memberships")