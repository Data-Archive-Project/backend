from django.core.exceptions import ValidationError
from django.utils.translation import gettext as _


class NumericPINValidator:

    def validate(self, password, user=None):
        if not password.isdigit():
            raise ValidationError(
                _("The PIN must contain only numeric digits."),
                code='password_entirely_numeric',
            )
        if len(password) != 5:
            raise ValidationError(
                _("The PIN must be exactly 5 digits long."),
                code='password_length',
            )

    def get_help_text(self):
        return _("Your PIN must be exactly 5 digits long and contain only numeric digits.")
