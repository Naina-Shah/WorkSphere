from datetime import datetime

from sqlalchemy import DateTime, String, func, CheckConstraint
from sqlalchemy.orm import Mapped, mapped_column, relationship

from backend.app.database import Base


class User(Base):
    __tablename__ = "users"

    __table_args__ = (
    CheckConstraint(
        "length(trim(full_name)) > 0",
        name="ck_user_name_not_empty"
    ),
    CheckConstraint(
        "position('@' in email) > 1",
        name="ck_user_email_valid"
    ),
)

    user_id: Mapped[int] = mapped_column(
        primary_key=True,
        index=True
    )

    full_name: Mapped[str] = mapped_column(
        String(150),
        nullable=False
    )

    user_email: Mapped[str] = mapped_column(
        String(255),
        unique=True,
        nullable=False,
        index=True
    )

    user_password: Mapped[str] = mapped_column(
        String(255),
        nullable=False
    )

    active_user: Mapped[bool] = mapped_column(
        default=True,
        nullable=False
    )

    created_user: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        server_default=func.now(),
        nullable=False
    )

    profile = relationship(
    "UserProfile",
    back_populates="user",
    uselist=False,
    cascade="all, delete-orphan"
    )

    team_members = relationship(
    "TeamMember",
    back_populates="user",
    cascade="all, delete-orphan"
    )

    task_assignments = relationship(
        "TaskAssignee",
        back_populates="user",
        cascade="all, delete-orphan"
    )

    company_memberships = relationship(
    "CompanyUser",
    back_populates="user",
    cascade="all, delete-orphan"
)

    skills = relationship(
    "UserSkill",
    back_populates="user",
    cascade="all, delete-orphan"
)

    activity_logs = relationship(
    "ActivityLog",
    back_populates="user"
)