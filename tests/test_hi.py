from src.project.hi import greeting


def test_greeting():
    result = greeting()
    assert isinstance(result, str)
    assert result == "Hello, world!"
