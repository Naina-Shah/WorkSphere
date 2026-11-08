from sqlalchemy import ForeignKey, String, Text
from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy import CheckConstraint

from backend.app.database import Base


class Software(Base):
    __tablename__ = "software"
    __table_args__ = (
        CheckConstraint(
            "length(trim(name)) > 0",
            name="ck_software_name_not_empty"
        ),
    )


    software_id: Mapped[int] = mapped_column(
        primary_key=True
    )

    company_id: Mapped[int] = mapped_column(
        ForeignKey("companies.company_id", ondelete="CASCADE"),
        nullable=False
    )

    name: Mapped[str] = mapped_column(
        String(150),
        nullable=False
    )

    description: Mapped[str | None] = mapped_column(
        Text,
        nullable=True
    )
    company = relationship("Company", back_populates="softwares")
    projects = relationship(
    "Project",
    back_populates="software",
    cascade="all, delete-orphan"
)