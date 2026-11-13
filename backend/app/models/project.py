from datetime import date

from sqlalchemy import Date, ForeignKey, String, Text
from sqlalchemy.orm import Mapped, mapped_column, relationship

from backend.app.database import Base
from sqlalchemy import CheckConstraint

class Project(Base):
    __tablename__ = "projects"

    __table_args__ = (
    CheckConstraint(
        "end_date IS NULL OR start_date IS NULL OR end_date >= start_date",
        name="ck_project_dates"
    ),
    CheckConstraint(
        "status IN ('planned', 'active', 'completed', 'cancelled')",
        name="ck_project_status"
    ),
)

    project_id: Mapped[int] = mapped_column(
        primary_key=True
    )

    software_id: Mapped[int] = mapped_column(
        ForeignKey("software.software_id", ondelete="CASCADE"),
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

    status: Mapped[str] = mapped_column(
        String(30),
        default="planned",
        nullable=False
    )

    start_date: Mapped[date | None] = mapped_column(
        Date,
        nullable=True
    )

    end_date: Mapped[date | None] = mapped_column(
        Date,
        nullable=True
    )

    software = relationship("Software", back_populates="projects")
    teams = relationship("Team", back_populates="project")
    tasks = relationship("Task", back_populates="project")
    subscriptions = relationship("Subscription", back_populates="project")



