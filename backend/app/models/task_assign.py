
from sqlalchemy import ForeignKey
from sqlalchemy.orm import Mapped, mapped_column,relationship

from backend.app.database import Base


class TaskAssignee(Base):
    __tablename__ = "task_assignees"

    task_id: Mapped[int] = mapped_column(
        ForeignKey("tasks.task_id", ondelete="CASCADE"),
        primary_key=True
    )
    user_id: Mapped[int] = mapped_column(
        ForeignKey("users.user_id", ondelete="CASCADE"),
        primary_key=True
    )

    task = relationship("Task", back_populates="assignees")
    user = relationship("User", back_populates="task_assignments")
