from sqlalchemy import ForeignKey, String, Text
from sqlalchemy.orm import Mapped, mapped_column, relationship

from backend.app.database import Base


class UserProfile(Base):
    __tablename__ = "user_profiles"

    user_id: Mapped[int] = mapped_column(
        ForeignKey("users.user_id", ondelete="CASCADE"),
        primary_key=True
    )

    job_title: Mapped[str | None] = mapped_column(
        String(100),
        nullable=True
    )

    bio: Mapped[str | None] = mapped_column(
        Text,
        nullable=True
    )

    profile_picture: Mapped[str | None] = mapped_column(
        String(255),
        nullable=True
    )
    user = relationship(
    "User",
    back_populates="profile"
)