import unittest
from htmlnode import HTMLNode


class TestHTMLNode(unittest.TestCase):
    def test_values(self):
        node = HTMLNode("p", "This is a html node")
        self.assertEqual(node.tag, "p")
        self.assertEqual(node.value, "This is a html node")
        self.assertEqual(node.children, None)
        self.assertEqual(node.props, None)

    def test_repr(self):
        node = HTMLNode("p", "This is a html node", None, {"class": "primary"})
        self.assertEqual(
            repr(node),
            "HTMLNode(p, This is a html node, children: None, {'class': 'primary'})",
        )

    def test_to_html_props(self):
        props = {"href": "https://boot.dev", "target": "_blank"}
        node = HTMLNode("a", "This is a html node", None, props)
        self.assertEqual(
            node.props_to_html(),
            ' href="https://boot.dev" target="_blank"',
        )


if __name__ == "__main__":
    unittest.main()
