from datetime import datetime

from sqlalchemy import DateTime, String, func
from sqlalchemy.orm import Mapped, mapped_column, relationship

from backend.app.database import Base


class Company(Base):
    __tablename__ = "companies"

    company_id: Mapped[int] = mapped_column(
        primary_key=True,
        index=True
    )

    company_name: Mapped[str] = mapped_column(
        String(150),
        nullable=False
    )

    company_email: Mapped[str] = mapped_column(
        String(255),
        unique=True,
        nullable=False,
        index=True
    )

    company_phone: Mapped[str | None] = mapped_column(
        String(20),
        nullable=True
    )

    company_address: Mapped[str | None] = mapped_column(
        String(255),
        nullable=True
    )

    company_created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        server_default=func.now(),
        nullable=False
    )
    softwares = relationship(
    "Software",
    back_populates="company",
    cascade="all, delete-orphan"
)

    memberships = relationship(
    "CompanyUser",
    back_populates="company",
    cascade="all, delete-orphan"
)