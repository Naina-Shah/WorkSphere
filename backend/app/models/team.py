from datetime import datetime

from sqlalchemy import DateTime, ForeignKey, String, Text, func, CheckConstraint
from sqlalchemy.orm import Mapped, mapped_column, relationship

from backend.app.database import Base


class Team(Base):
    __tablename__ = "teams"
    __table_args__ = (
    CheckConstraint(
        "length(trim(name)) > 0",
        name="ck_team_name_not_empty"
    ),
)

    team_id: Mapped[int] = mapped_column(primary_key=True)
    project_id: Mapped[int] = mapped_column(
        ForeignKey("projects.project_id", ondelete="CASCADE"),
        nullable=False
    )
    team_name: Mapped[str] = mapped_column(String(150), nullable=False)
    team_description: Mapped[str | None] = mapped_column(Text, nullable=True)
    team_created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        server_default=func.now(),
        nullable=False
    )
    project = relationship("Project", back_populates="teams")

    members = relationship(
        "TeamMember",
        back_populates="team",
        cascade="all, delete-orphan"
    )