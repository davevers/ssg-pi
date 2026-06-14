from textnode import TextNode, TextType


def split_nodes_delimiter(
    old_nodes: list[TextNode], delimiter: str, text_type: TextType
) -> list[TextNode]:
    new_nodes = []
    for node in old_nodes:
        if node.text_type != TextType.TEXT:
            new_nodes.append(node)
            continue
        split_nodes = []
        sections = node.text.split(delimiter)
        if len(sections) % 2 == 0:
            raise ValueError("invalid markdown, formatted section not closed")
        for n in range(len(sections)):
            if sections[n] == "":
                continue
            if n % 2 != 0:
                split_nodes.append(TextNode(sections[n], text_type))
            else:
                split_nodes.append(TextNode(sections[n], TextType.TEXT))
        new_nodes.extend(split_nodes)
    return new_nodes
