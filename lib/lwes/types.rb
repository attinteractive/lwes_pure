module Lwes
  TYPE_TO_BYTE = {
    :uint16               => 1,
    :int16                => 2,
    :uint32               => 3,
    :int32                => 4,
    :attr_str             => 5,
    :ip_addr              => 6,
    :int64                => 7,
    :uint64               => 8,
    :boolean              => 9,
    :uint8                => 10,
    :float                => 11,
    :double               => 12,
    :ip_v4                => 13,

    :uint16_array         => 129,
    :int16_array          => 130,
    :uint32_array         => 131,
    :int32_array          => 132,
    :attr_str_array       => 133,
    :ip_addr_array        => 134,
    :int64_array          => 135,
    :uint64_array         => 136,
    :boolean_array        => 137,
    :uint8_array          => 138,
    :float_array          => 139,
    :double_array         => 140,
    :ip_v4_array          => 141
  }
  
  BYTE_TO_TYPE = TYPE_TO_BYTE.invert
end