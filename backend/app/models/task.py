from datetime import date

from sqlalchemy import Date, ForeignKey, String, Text
from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy import CheckConstraint
from backend.app.database import Base


class Task(Base):
    __tablename__ = "tasks"

    __table_args__ = (
    CheckConstraint(
        "status IN ('pending', 'in_progress', 'completed', 'cancelled')",
        name="ck_task_status"
    ),
)


    task_id: Mapped[int] = mapped_column(primary_key=True)
    project_id: Mapped[int] = mapped_column(
        ForeignKey("projects.project_id", ondelete="CASCADE"),
        nullable=False
    )
    name: Mapped[str] = mapped_column(String(150), nullable=False)
    description: Mapped[str | None] = mapped_column(Text, nullable=True)
    status: Mapped[str] = mapped_column(
        String(30), default="pending", nullable=False
    )
    due_date: Mapped[date | None] = mapped_column(Date, nullable=True)

    project = relationship("Project", back_populates="tasks")

    assignees = relationship(
        "TaskAssignee",
        back_populates="task",
        cascade="all, delete-orphan"
    )
