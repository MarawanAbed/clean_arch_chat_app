enum MessageType {
  textType,
  imageType,
  text,
  image,
}

MessageType getMessageTypeFromString(String json) {
  switch (json) {
    case 'text':
      return MessageType.textType;
    case 'image':
      return MessageType.imageType;
    default:
      throw Exception('Unsupported MessageType: $json');
  }
}