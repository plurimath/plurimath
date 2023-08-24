module ExpectedValues
  EX_001 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Frac.new(
      Plurimath::Math::Number.new("1"),
    )
  ])
  EX_002 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Frac.new(
      Plurimath::Math::Number.new("1"),
      Plurimath::Math::Number.new("2"),
    )
  ])
  EX_004 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Frac.new(
      Plurimath::Math::Number.new("1"),
      Plurimath::Math::Number.new("2"),
    )
  ])
  EX_005 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Power.new(
      Plurimath::Math::Number.new("1"),
      Plurimath::Math::Number.new("2"),
    )
  ])
  EX_006 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Base.new(
      Plurimath::Math::Number.new("1"),
      Plurimath::Math::Number.new("2"),
    )
  ])
  EX_007 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::PowerBase.new(
      Plurimath::Math::Number.new("1"),
      Plurimath::Math::Number.new("3"),
      Plurimath::Math::Number.new("2"),
    )
  ])
  EX_008 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Multiscript.new(
      Plurimath::Math::Number.new("2"),
      Plurimath::Math::Number.new("3"),
      Plurimath::Math::Number.new("1"),
    )
  ])
  EX_009 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Sqrt.new(
      Plurimath::Math::Number.new("1")
    )
  ])
  EX_010 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Root.new(
      Plurimath::Math::Number.new("1"),
      Plurimath::Math::Number.new("2"),
    )
  ])
  EX_011 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Root.new(
      Plurimath::Math::Number.new("3"),
      Plurimath::Math::Number.new("2"),
    )
  ])
  EX_012 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Root.new(
      Plurimath::Math::Number.new("1"),
      Plurimath::Math::Number.new("3"),
    )
  ])
  EX_013 = Plurimath::Math::Formula.new([
    Plurimath::Math::Formula.new([
      Plurimath::Math::Function::Underover.new(
        Plurimath::Math::Symbol.new("&#x222b;"),
      ),
      Plurimath::Math::Number.new("1"),
    ])
  ])
  EX_014 = Plurimath::Math::Formula.new([
    Plurimath::Math::Formula.new([
      Plurimath::Math::Function::PowerBase.new(
        Plurimath::Math::Symbol.new("&#x222b;"),
        Plurimath::Math::Number.new("2"),
        Plurimath::Math::Number.new("1"),
      ),
      Plurimath::Math::Number.new("3"),
    ])
  ])
  EX_015 = Plurimath::Math::Formula.new([
    Plurimath::Math::Formula.new([
      Plurimath::Math::Function::Underover.new(
        Plurimath::Math::Symbol.new("&#x222b;"),
        Plurimath::Math::Number.new("2"),
        Plurimath::Math::Number.new("1"),
      ),
      Plurimath::Math::Number.new("3"),
    ])
  ])
  EX_016 = Plurimath::Math::Formula.new([
    Plurimath::Math::Formula.new([
      Plurimath::Math::Function::Underover.new(
        Plurimath::Math::Symbol.new("&#x222c;"),
      ),
      Plurimath::Math::Number.new("1"),
    ])
  ])
  EX_003 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Frac.new(
      Plurimath::Math::Number.new("1"),
      Plurimath::Math::Number.new("2"),
    )
  ])
  EX_017 = Plurimath::Math::Formula.new([
    Plurimath::Math::Formula.new([
      Plurimath::Math::Function::PowerBase.new(
        Plurimath::Math::Symbol.new("&#x222c;"),
        Plurimath::Math::Number.new("2"),
        Plurimath::Math::Number.new("1"),
      ),
      Plurimath::Math::Number.new("3")
    ])
  ])
  EX_018 = Plurimath::Math::Formula.new([
    Plurimath::Math::Formula.new([
      Plurimath::Math::Function::Underover.new(
        Plurimath::Math::Symbol.new("&#x222c;"),
        Plurimath::Math::Number.new("2"),
        Plurimath::Math::Number.new("1"),
      ),
      Plurimath::Math::Number.new("3")
    ])
  ])
  EX_019 = Plurimath::Math::Formula.new([
    Plurimath::Math::Formula.new([
      Plurimath::Math::Function::Underover.new(
        Plurimath::Math::Symbol.new("&#x222d;"),
      ),
      Plurimath::Math::Number.new("1")
    ])
  ])
  EX_020 = Plurimath::Math::Formula.new([
    Plurimath::Math::Formula.new([
      Plurimath::Math::Function::PowerBase.new(
        Plurimath::Math::Symbol.new("&#x222d;"),
        Plurimath::Math::Number.new("2"),
        Plurimath::Math::Number.new("1"),
      ),
      Plurimath::Math::Number.new("3")
    ])
  ])
  EX_021 = Plurimath::Math::Formula.new([
    Plurimath::Math::Formula.new([
      Plurimath::Math::Function::Underover.new(
        Plurimath::Math::Symbol.new("&#x222d;"),
        Plurimath::Math::Number.new("2"),
        Plurimath::Math::Number.new("1"),
      ),
      Plurimath::Math::Number.new("3")
    ])
  ])
  EX_022 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Oint.new(
      nil,
      nil,
      Plurimath::Math::Number.new("1")
    ),
  ])
  EX_023 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Oint.new(
      Plurimath::Math::Number.new("2"),
      Plurimath::Math::Number.new("1"),
      Plurimath::Math::Number.new("3")
    ),
  ])
  EX_024 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Oint.new(
      Plurimath::Math::Number.new("2"),
      Plurimath::Math::Number.new("1"),
      Plurimath::Math::Number.new("3")
    ),
  ])
  EX_025 = Plurimath::Math::Formula.new([
    Plurimath::Math::Formula.new([
      Plurimath::Math::Function::Underover.new(
        Plurimath::Math::Symbol.new("&#x222f;"),
      ),
      Plurimath::Math::Number.new("1")
    ])
  ])
  EX_026 = Plurimath::Math::Formula.new([
    Plurimath::Math::Formula.new([
      Plurimath::Math::Function::PowerBase.new(
        Plurimath::Math::Symbol.new("&#x222f;"),
        Plurimath::Math::Number.new("2"),
        Plurimath::Math::Number.new("1"),
      ),
      Plurimath::Math::Number.new("3")
    ])
  ])
  EX_027 = Plurimath::Math::Formula.new([
    Plurimath::Math::Formula.new([
      Plurimath::Math::Function::Underover.new(
        Plurimath::Math::Symbol.new("&#x222f;"),
        Plurimath::Math::Number.new("2"),
        Plurimath::Math::Number.new("1"),
      ),
      Plurimath::Math::Number.new("3")
    ])
  ])
  EX_028 = Plurimath::Math::Formula.new([
    Plurimath::Math::Formula.new([
      Plurimath::Math::Function::Underover.new(
        Plurimath::Math::Symbol.new("&#x2230;"),
      ),
      Plurimath::Math::Number.new("1")
    ])
  ])
  EX_029 = Plurimath::Math::Formula.new([
    Plurimath::Math::Formula.new([
      Plurimath::Math::Function::PowerBase.new(
        Plurimath::Math::Symbol.new("&#x2230;"),
        Plurimath::Math::Number.new("2"),
        Plurimath::Math::Number.new("1"),
      ),
      Plurimath::Math::Number.new("3")
    ])
  ])
  EX_030 = Plurimath::Math::Formula.new([
    Plurimath::Math::Formula.new([
      Plurimath::Math::Function::Underover.new(
        Plurimath::Math::Symbol.new("&#x2230;"),
        Plurimath::Math::Number.new("1"),
        Plurimath::Math::Number.new("2"),
      ),
      Plurimath::Math::Number.new("3")
    ])
  ])
  EX_031 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Text.new("dx"),
  ])
  EX_032 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Text.new("dy"),
  ])
  EX_033 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Text.new("dθ"),
  ])
  EX_034 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Sum.new(
      nil,
      nil,
      Plurimath::Math::Number.new("1")
    ),
  ])
  EX_035 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Sum.new(
      Plurimath::Math::Number.new("3"),
      Plurimath::Math::Number.new("1"),
      Plurimath::Math::Number.new("2")
    ),
  ])
  EX_036 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Sum.new(
      Plurimath::Math::Number.new("3"),
      Plurimath::Math::Number.new("1"),
      Plurimath::Math::Number.new("2")
    ),
  ])
  EX_037 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Sum.new(
      Plurimath::Math::Number.new("2"),
      nil,
      Plurimath::Math::Number.new("1")
    ),
  ])
  EX_038 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Sum.new(
      Plurimath::Math::Number.new("1"),
      nil,
      Plurimath::Math::Number.new("2")
    ),
  ])
  EX_039 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Prod.new(
      Plurimath::Math::Number.new("3"),
      Plurimath::Math::Number.new("1"),
      Plurimath::Math::Number.new("2")
    ),
  ])
  EX_040 = Plurimath::Math::Formula.new([
    Plurimath::Math::Formula.new([
      Plurimath::Math::Function::Underover.new(
        Plurimath::Math::Symbol.new("&#x2210;"),
        Plurimath::Math::Number.new("3"),
        Plurimath::Math::Number.new("1"),
      ),
      Plurimath::Math::Number.new("2")
    ])
  ])
  EX_041 = Plurimath::Math::Formula.new([
    Plurimath::Math::Formula.new([
      Plurimath::Math::Function::Underover.new(
        Plurimath::Math::Symbol.new("&#x22c3;"),
        Plurimath::Math::Number.new("2"),
        Plurimath::Math::Number.new("1"),
      ),
      Plurimath::Math::Number.new("3")
    ])
  ])
  EX_042 = Plurimath::Math::Formula.new([
    Plurimath::Math::Formula.new([
      Plurimath::Math::Function::Underover.new(
        Plurimath::Math::Symbol.new("&#x22c2;"),
        Plurimath::Math::Number.new("3"),
        Plurimath::Math::Number.new("1"),
      ),
      Plurimath::Math::Number.new("2")
    ])
  ])
  EX_043 = Plurimath::Math::Formula.new([
    Plurimath::Math::Formula.new([
      Plurimath::Math::Function::Underover.new(
        Plurimath::Math::Symbol.new("&#x22c1;"),
        Plurimath::Math::Number.new("1"),
        nil,
      ),
      Plurimath::Math::Number.new("2")
    ])
  ])
  EX_044 = Plurimath::Math::Formula.new([
    Plurimath::Math::Formula.new([
      Plurimath::Math::Function::Underover.new(
        Plurimath::Math::Symbol.new("&#x22c0;"),
        Plurimath::Math::Number.new("1"),
        Plurimath::Math::Number.new("2"),
      ),
      Plurimath::Math::Number.new("3")
    ])
  ])
  EX_045 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Sum.new(
      Plurimath::Math::Function::Text.new("k"),
      nil,
      Plurimath::Math::Function::Fenced.new(
        nil,
        [
          Plurimath::Math::Function::Frac.new(
            Plurimath::Math::Function::Text.new("n"),
            Plurimath::Math::Function::Text.new("k"),
          ),
        ],
        nil,
      )
    ),
  ])
  EX_046 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Sum.new(
      Plurimath::Math::Function::Text.new("i=0"),
      Plurimath::Math::Function::Text.new("n"),
      Plurimath::Math::Function::Text.new("x")
    ),
  ])
  EX_047 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Sum.new(
      Plurimath::Math::Function::Table.new(
        [
          Plurimath::Math::Function::Tr.new([
            Plurimath::Math::Function::Td.new([
              Plurimath::Math::Function::Text.new("0≤ i ≤ m")
            ])
          ]),
          Plurimath::Math::Function::Tr.new([
            Plurimath::Math::Function::Td.new([
              Plurimath::Math::Function::Text.new("0<j<n ")
            ])
          ])
        ],
        nil,
        nil,
      ),
      nil,
      Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Text.new("P"),
        Plurimath::Math::Function::Fenced.new(
          nil,
          [
            Plurimath::Math::Function::Text.new("i,j"),
          ],
          nil,
        ),
      ])
    ),
  ])
  EX_048 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Prod.new(
      Plurimath::Math::Function::Text.new("k=1"),
      Plurimath::Math::Function::Text.new("n"),
      Plurimath::Math::Function::Base.new(
        Plurimath::Math::Function::Text.new("A"),
        Plurimath::Math::Function::Text.new("k")
      )
    ),
  ])
  EX_049 = Plurimath::Math::Formula.new([
    Plurimath::Math::Formula.new([
      Plurimath::Math::Function::Underover.new(
        Plurimath::Math::Symbol.new("&#x22c3;"),
        Plurimath::Math::Function::Text.new("n=1"),
        Plurimath::Math::Function::Text.new("m"),
      ),
      Plurimath::Math::Function::Fenced.new(
        nil,
        [
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("X"),
            Plurimath::Math::Function::Text.new("n")
          ),
          Plurimath::Math::Symbol.new("∩"),
          Plurimath::Math::Function::Base.new(
            Plurimath::Math::Function::Text.new("Y"),
            Plurimath::Math::Function::Text.new("n")
          )
        ],
        nil,
      )
    ])
  ])
  EX_050 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Fenced.new(
      nil,
      [
        Plurimath::Math::Number.new("1"),
      ],
      nil,
    )
  ])
  EX_051 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Fenced.new(
      Plurimath::Math::Symbol.new("["),
      [
        Plurimath::Math::Number.new("2"),
      ],
      Plurimath::Math::Symbol.new("]"),
    )
  ])
  EX_052 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Fenced.new(
      Plurimath::Math::Symbol.new("{"),
      [
        Plurimath::Math::Number.new("3"),
      ],
      Plurimath::Math::Symbol.new("}"),
    )
  ])
  EX_053 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Fenced.new(
      Plurimath::Math::Symbol.new("〈"),
      [
        Plurimath::Math::Number.new("4"),
      ],
      Plurimath::Math::Symbol.new("〉"),
    )
  ])
  EX_054 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Fenced.new(
      Plurimath::Math::Symbol.new("⌊"),
      [
        Plurimath::Math::Number.new("5"),
      ],
      Plurimath::Math::Symbol.new("⌋"),
    )
  ])
  EX_055 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Fenced.new(
      Plurimath::Math::Symbol.new("⌈"),
      [
        Plurimath::Math::Number.new("6"),
      ],
      Plurimath::Math::Symbol.new("⌉"),
    )
  ])
  EX_056 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Fenced.new(
      Plurimath::Math::Symbol.new("|"),
      [
        Plurimath::Math::Number.new("7"),
      ],
      Plurimath::Math::Symbol.new("|"),
    )
  ])
  EX_057 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Fenced.new(
      Plurimath::Math::Symbol.new("‖"),
      [
        Plurimath::Math::Number.new("8"),
      ],
      Plurimath::Math::Symbol.new("‖"),
    )
  ])
  EX_058 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Fenced.new(
      Plurimath::Math::Symbol.new("["),
      [
        Plurimath::Math::Number.new("9"),
      ],
      Plurimath::Math::Symbol.new("["),
    )
  ])
  EX_059 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Fenced.new(
      Plurimath::Math::Symbol.new("]"),
      [
        Plurimath::Math::Number.new("0"),
      ],
      Plurimath::Math::Symbol.new("]"),
    )
  ])
  EX_060 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Fenced.new(
      Plurimath::Math::Symbol.new("]"),
      [
        Plurimath::Math::Number.new("1"),
      ],
      Plurimath::Math::Symbol.new("["),
    )
  ])
  EX_061 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Fenced.new(
      Plurimath::Math::Symbol.new("⟦"),
      [
        Plurimath::Math::Number.new("2"),
      ],
      Plurimath::Math::Symbol.new("⟧"),
    )
  ])
  EX_062 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Fenced.new(
      nil,
      [
        Plurimath::Math::Number.new("1"),
        Plurimath::Math::Number.new("2"),
      ],
      nil,
    )
  ])
  EX_063 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Fenced.new(
      Plurimath::Math::Symbol.new("{"),
      [
        Plurimath::Math::Number.new("3"),
        Plurimath::Math::Number.new("4"),
      ],
      Plurimath::Math::Symbol.new("}"),
    )
  ])
  EX_064 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Fenced.new(
      Plurimath::Math::Symbol.new("⟨"),
      [
        Plurimath::Math::Number.new("5"),
        Plurimath::Math::Number.new("6"),
      ],
      Plurimath::Math::Symbol.new("⟩"),
    )
  ])
  EX_065 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Fenced.new(
      Plurimath::Math::Symbol.new("⟨"),
      [
        Plurimath::Math::Number.new("7"),
        Plurimath::Math::Number.new("8"),
        Plurimath::Math::Number.new("9"),
      ],
      Plurimath::Math::Symbol.new("⟩"),
    )
  ])
  EX_066 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Fenced.new(
      Plurimath::Math::Symbol.new("{"),
      [
        Plurimath::Math::Function::Table.new(
          [
            Plurimath::Math::Function::Tr.new([
              Plurimath::Math::Function::Td.new([
                Plurimath::Math::Number.new("1"),
              ])
            ]),
            Plurimath::Math::Function::Tr.new([
              Plurimath::Math::Function::Td.new([
                Plurimath::Math::Number.new("2"),
              ])
            ])
          ],
          nil,
          nil,
        )
      ],
      nil,
    )
  ])
  EX_067 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Fenced.new(
      Plurimath::Math::Symbol.new("{"),
      [
        Plurimath::Math::Function::Table.new(
          [
            Plurimath::Math::Function::Tr.new([
              Plurimath::Math::Function::Td.new([
                Plurimath::Math::Number.new("1")
              ])
            ]),
            Plurimath::Math::Function::Tr.new([
              Plurimath::Math::Function::Td.new([
                Plurimath::Math::Number.new("2")
              ])
            ]),
            Plurimath::Math::Function::Tr.new([
              Plurimath::Math::Function::Td.new([
                Plurimath::Math::Number.new("3")
              ])
            ])
          ],
          nil,
          nil
        )
      ],
      nil,
    )
  ])
  EX_068 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Frac.new(
      Plurimath::Math::Function::Text.new("a"),
      Plurimath::Math::Function::Text.new("b"),
    )
  ])
  EX_069 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Fenced.new(
      nil,
      [
        Plurimath::Math::Function::Frac.new(
          Plurimath::Math::Function::Text.new("n"),
          Plurimath::Math::Function::Text.new("m"),
        )
      ],
      nil,
    )
  ])
  EX_070 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Text.new("f"),
    Plurimath::Math::Function::Fenced.new(
      nil,
      [
        Plurimath::Math::Function::Text.new("x")
      ],
      nil,
    ),
    Plurimath::Math::Symbol.new("="),
    Plurimath::Math::Function::Fenced.new(
      Plurimath::Math::Symbol.new("{"),
      [
        Plurimath::Math::Function::Table.new(
          [
            Plurimath::Math::Function::Tr.new([
              Plurimath::Math::Function::Td.new([
                Plurimath::Math::Function::Text.new("-x,  &x<0")
              ])
            ]),
            Plurimath::Math::Function::Tr.new([
              Plurimath::Math::Function::Td.new([
                Plurimath::Math::Function::Text.new("x,  &x≥0")
              ])
            ])
          ],
          nil,
          nil,
        )
      ],
      nil,
    )
  ])
  EX_071 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Fenced.new(
      nil,
      [
        Plurimath::Math::Function::Frac.new(
          Plurimath::Math::Function::Text.new("n"),
          Plurimath::Math::Function::Text.new("k"),
        )
      ],
      nil,
    )
  ])
  EX_072 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Fenced.new(
      Plurimath::Math::Symbol.new("⟨"),
      [
        Plurimath::Math::Function::Frac.new(
          Plurimath::Math::Function::Text.new("n"),
          Plurimath::Math::Function::Text.new("k"),
        )
      ],
      Plurimath::Math::Symbol.new("⟩"),
    )
  ])
  EX_073 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Sin.new(
      Plurimath::Math::Function::Text.new("x"),
    )
  ])
  EX_074 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Cos.new(
      Plurimath::Math::Function::Text.new("x"),
    )
  ])
  EX_075 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Tan.new(
      Plurimath::Math::Function::Text.new("x"),
    )
  ])
  EX_076 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Csc.new(
      Plurimath::Math::Function::Text.new("x"),
    )
  ])
  EX_077 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Sec.new(
      Plurimath::Math::Function::Text.new("x"),
    )
  ])
  EX_078 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Cot.new(
      Plurimath::Math::Function::Text.new("x"),
    )
  ])
  EX_079 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Power.new(
      Plurimath::Math::Function::Sin.new,
      Plurimath::Math::Symbol.new("-1"),
    ),
    Plurimath::Math::Function::Text.new("x"),
  ])
  EX_080 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Power.new(
      Plurimath::Math::Function::Cos.new,
      Plurimath::Math::Symbol.new("-1"),
    ),
    Plurimath::Math::Function::Text.new("x"),
  ])
  EX_081 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Power.new(
      Plurimath::Math::Function::Tan.new,
      Plurimath::Math::Symbol.new("-1"),
    ),
    Plurimath::Math::Function::Text.new("x"),
  ])
  EX_082 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Power.new(
      Plurimath::Math::Function::Csc.new,
      Plurimath::Math::Symbol.new("-1"),
    ),
    Plurimath::Math::Function::Text.new("x"),
  ])
  EX_083 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Power.new(
      Plurimath::Math::Function::Sec.new,
      Plurimath::Math::Symbol.new("-1"),
    ),
    Plurimath::Math::Function::Text.new("x"),
  ])
  EX_084 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Power.new(
      Plurimath::Math::Function::Cot.new,
      Plurimath::Math::Symbol.new("-1"),
    ),
    Plurimath::Math::Function::Text.new("x"),
  ])
  EX_085 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Sinh.new(
      Plurimath::Math::Function::Text.new("x")
    ),
  ])
  EX_086 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Cosh.new(
      Plurimath::Math::Function::Text.new("x")
    ),
  ])
  EX_087 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Tanh.new(
      Plurimath::Math::Function::Text.new("x")
    ),
  ])
  EX_088 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Csch.new(
      Plurimath::Math::Function::Text.new("x")
    ),
  ])
  EX_089 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Sech.new(
      Plurimath::Math::Function::Text.new("x")
    ),
  ])
  EX_090 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Coth.new(
      Plurimath::Math::Function::Text.new("x")
    ),
  ])
  EX_091 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Power.new(
      Plurimath::Math::Function::Sinh.new,
      Plurimath::Math::Symbol.new("-1")
    ),
    Plurimath::Math::Function::Text.new("x")
  ])
  EX_092 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Power.new(
      Plurimath::Math::Function::Cosh.new,
      Plurimath::Math::Symbol.new("-1")
    ),
    Plurimath::Math::Function::Text.new("x")
  ])
  EX_093 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Power.new(
      Plurimath::Math::Function::Tanh.new,
      Plurimath::Math::Symbol.new("-1")
    ),
    Plurimath::Math::Function::Text.new("x")
  ])
  EX_094 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Power.new(
      Plurimath::Math::Function::Csch.new,
      Plurimath::Math::Symbol.new("-1"),
    ),
    Plurimath::Math::Function::Text.new("x")
  ])
  EX_095 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Power.new(
      Plurimath::Math::Function::Sech.new,
      Plurimath::Math::Symbol.new("-1")
    ),
    Plurimath::Math::Function::Text.new("x")
  ])
  EX_096 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Power.new(
      Plurimath::Math::Function::Coth.new,
      Plurimath::Math::Symbol.new("-1")
    ),
    Plurimath::Math::Function::Text.new("x")
  ])
  EX_097 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Sin.new(
      Plurimath::Math::Symbol.new("θ")
    )
  ])
  EX_098 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Cos.new(
      Plurimath::Math::Function::Text.new("2x")
    )
  ])
  EX_099 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Tan.new(
      Plurimath::Math::Symbol.new("θ"),
    ),
    Plurimath::Math::Symbol.new("="),
    Plurimath::Math::Function::Frac.new(
      Plurimath::Math::Function::Sin.new(
        Plurimath::Math::Symbol.new("θ")
      ),
      Plurimath::Math::Function::Cos.new(
        Plurimath::Math::Symbol.new("θ"),
      )
    )
  ])
  EX_100 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Overset.new(
      Plurimath::Math::Symbol.new("̇"),
      Plurimath::Math::Function::Text.new("a"),
    )
  ])
  EX_101 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Overset.new(
      Plurimath::Math::Symbol.new("̈"),
      Plurimath::Math::Function::Text.new("a"),
    )
  ])
  EX_102 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Overset.new(
      Plurimath::Math::Symbol.new("⃛"),
      Plurimath::Math::Function::Text.new("a"),
    )
  ])
  EX_103 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Hat.new(
      Plurimath::Math::Function::Text.new("a"),
      { accent: true },
    )
  ])
  EX_104 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Overset.new(
      Plurimath::Math::Symbol.new("̌"),
      Plurimath::Math::Function::Text.new("b"),
    )
  ])
  EX_105 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Overset.new(
      Plurimath::Math::Symbol.new("́"),
      Plurimath::Math::Function::Text.new("b"),
    )
  ])
  EX_106 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Overset.new(
      Plurimath::Math::Symbol.new("̀"),
      Plurimath::Math::Function::Text.new("b"),
    )
  ])
  EX_107 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Overset.new(
      Plurimath::Math::Symbol.new("̆"),
      Plurimath::Math::Function::Text.new("b"),
    )
  ])
  EX_108 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Overset.new(
      Plurimath::Math::Symbol.new("̃"),
      Plurimath::Math::Function::Text.new("c"),
    )
  ])
  EX_109 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Overset.new(
      Plurimath::Math::Symbol.new("̅"),
      Plurimath::Math::Function::Text.new("c"),
    )
  ])
  EX_110 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Overset.new(
      Plurimath::Math::Symbol.new("̿"),
      Plurimath::Math::Function::Text.new("c"),
    )
  ])
  EX_111 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Obrace.new(
      Plurimath::Math::Function::Text.new("c"),
      { accent: true },
    )
  ])
  EX_112 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Underset.new(
      Plurimath::Math::Function::Text.new("d"),
      Plurimath::Math::Symbol.new("&#x23df;"),
    )
  ])
  EX_113 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Overset.new(
      Plurimath::Math::Function::Text.new("d"),
      Plurimath::Math::Function::Obrace.new(
        Plurimath::Math::Function::Text.new("e"),
        { accent: true },
      ),
    )
  ])
  EX_114 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Underset.new(
      Plurimath::Math::Function::Text.new("e"),
      Plurimath::Math::Function::Underset.new(
        Plurimath::Math::Function::Text.new("d"),
        Plurimath::Math::Symbol.new("&#x23df;"),
      ),
    )
  ])
  EX_115 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Overset.new(
      Plurimath::Math::Function::Text.new("d"),
      Plurimath::Math::Symbol.new("⃖"),
    )
  ])
  EX_116 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Overset.new(
      Plurimath::Math::Function::Text.new("e"),
      Plurimath::Math::Symbol.new("⃗"),
    )
  ])
  EX_117 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Overset.new(
      Plurimath::Math::Function::Text.new("e"),
      Plurimath::Math::Symbol.new("⃡"),
    )
  ])
  EX_118 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Overset.new(
      Plurimath::Math::Function::Text.new("e"),
      Plurimath::Math::Symbol.new("⃐"),
    )
  ])
  EX_119 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Overset.new(
      Plurimath::Math::Function::Text.new("e"),
      Plurimath::Math::Symbol.new("⃑"),
    )
  ])
  EX_120 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Menclose.new(
      "longdiv",
      Plurimath::Math::Function::Text.new("ax+b"),
    )
  ])
  EX_121 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Menclose.new(
      "longdiv",
      Plurimath::Math::Formula.new([
        Plurimath::Math::Function::Power.new(
          Plurimath::Math::Function::Text.new( "a"),
          Plurimath::Math::Number.new("2")
        ),
        Plurimath::Math::Symbol.new("="),
        Plurimath::Math::Function::Power.new(
          Plurimath::Math::Function::Text.new( "b"),
          Plurimath::Math::Number.new("2")
        ),
        Plurimath::Math::Symbol.new("+"),
        Plurimath::Math::Function::Power.new(
          Plurimath::Math::Function::Text.new( "c"),
          Plurimath::Math::Number.new("2")
        )
      ])
    )
  ])
  EX_122 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Underset.new(
      Plurimath::Math::Function::Text.new("over"),
      Plurimath::Math::Function::FontStyle::Normal.new(
        Plurimath::Math::Symbol.new("‾"),
        "p",
      ),
    )
  ])
  EX_123 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Bar.new(
      Plurimath::Math::Function::Text.new("under"),
      { accent: false }
    )
  ])
  EX_124 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Underset.new(
      Plurimath::Math::Function::Text.new("A"),
      Plurimath::Math::Function::FontStyle::Normal.new(
        Plurimath::Math::Symbol.new("‾"),
        "p",
      ),
    )
  ])
  EX_125 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Underset.new(
      Plurimath::Math::Function::Text.new("ABC"),
      Plurimath::Math::Function::FontStyle::Normal.new(
        Plurimath::Math::Symbol.new("‾"),
        "p",
      ),
    )
  ])
  EX_126 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Underset.new(
      Plurimath::Math::Function::Text.new("x⊕y"),
      Plurimath::Math::Function::FontStyle::Normal.new(
        Plurimath::Math::Symbol.new("‾"),
        "p",
      ),
    )
  ])
  EX_127 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Base.new(
      Plurimath::Math::Function::Log.new,
      Plurimath::Math::Function::Text.new("a"),
    ),
    Plurimath::Math::Number.new("2"),
  ])
  EX_128 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Log.new(
      Plurimath::Math::Function::Text.new("x"),
      nil,
    )
  ])
  EX_129 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Underset.new(
      Plurimath::Math::Function::Text.new("lim"),
      Plurimath::Math::Function::Text.new("y"),
    ),
    Plurimath::Math::Function::Text.new("x"),
  ])
  EX_130 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Underset.new(
      Plurimath::Math::Function::Min.new,
      Plurimath::Math::Function::Text.new("y"),
    ),
    Plurimath::Math::Function::Text.new("x"),
  ])
  EX_131 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Underset.new(
      Plurimath::Math::Function::Max.new,
      Plurimath::Math::Function::Text.new("y"),
    ),
    Plurimath::Math::Function::Text.new("x"),
  ])
  EX_132 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Ln.new,
    Plurimath::Math::Function::Text.new("x"),
  ])
  EX_133 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Underset.new(
      Plurimath::Math::Function::Text.new("lim"),
      Plurimath::Math::Function::Text.new("n→∞"),
    ),
    Plurimath::Math::Function::Power.new(
      Plurimath::Math::Function::Fenced.new(
        nil,
        [
          Plurimath::Math::Number.new("1+"),
          Plurimath::Math::Function::Frac.new(
            Plurimath::Math::Number.new("1"),
            Plurimath::Math::Function::Text.new("n")
          )
        ],
        nil,
      ),
      Plurimath::Math::Function::Text.new("n"),
    )
  ])
  EX_134 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Underset.new(
      Plurimath::Math::Function::Max.new,
      Plurimath::Math::Function::Text.new("0≤x≤1"),
    ),
    Plurimath::Math::Function::Text.new("x"),
    Plurimath::Math::Function::Power.new(
      Plurimath::Math::Function::Text.new("e"),
      Plurimath::Math::Formula.new([
        Plurimath::Math::Symbol.new("-"),
        Plurimath::Math::Function::Power.new(
          Plurimath::Math::Function::Text.new("x"),
          Plurimath::Math::Number.new("2")
        )
      ])
    )
  ])
  EX_135 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Text.new("x"),
    Plurimath::Math::Symbol.new("∶="),
    Plurimath::Math::Function::Text.new("y")
  ])
  EX_136 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Text.new("a"),
    Plurimath::Math::Symbol.new("=="),
    Plurimath::Math::Function::Text.new("a")
  ])
  EX_137 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Text.new("a"),
    Plurimath::Math::Symbol.new("+="),
    Plurimath::Math::Function::Text.new("b")
  ])
  EX_138 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Text.new("a"),
    Plurimath::Math::Symbol.new("-="),
    Plurimath::Math::Function::Text.new("b")
  ])
  EX_139 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Text.new("a"),
    Plurimath::Math::Symbol.new("≝"),
    Plurimath::Math::Function::Text.new("b")
  ])
  EX_140 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Text.new("a"),
    Plurimath::Math::Symbol.new("≞"),
    Plurimath::Math::Function::Text.new("b"),
  ])
  EX_141 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Text.new("a"),
    Plurimath::Math::Symbol.new("≜"),
    Plurimath::Math::Function::Text.new("b")
  ])
  EX_142 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Overset.new(
      Plurimath::Math::Function::Text.new("c"),
      Plurimath::Math::Symbol.new("←"),
    )
  ])
  EX_143 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Overset.new(
      Plurimath::Math::Function::Text.new("c"),
      Plurimath::Math::Function::Vec.new,
    )
  ])
  EX_144 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Underset.new(
      Plurimath::Math::Function::Text.new("c"),
      Plurimath::Math::Symbol.new("←"),
    )
  ])
  EX_145 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Underset.new(
      Plurimath::Math::Function::Text.new("c"),
      Plurimath::Math::Symbol.new("&#x2192;"),
    )
  ])
  EX_146 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Overset.new(
      Plurimath::Math::Function::Text.new("d"),
      Plurimath::Math::Symbol.new("⇐"),
    )
  ])
  EX_147 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Overset.new(
      Plurimath::Math::Function::Text.new("d"),
      Plurimath::Math::Symbol.new("⇒"),
    )
  ])
  EX_148 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Underset.new(
      Plurimath::Math::Function::Text.new("d"),
      Plurimath::Math::Symbol.new("⇐"),
    )
  ])
  EX_149 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Underset.new(
      Plurimath::Math::Function::Text.new("d"),
      Plurimath::Math::Symbol.new("⇒"),
    )
  ])
  EX_150 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Overset.new(
      Plurimath::Math::Function::Text.new("e"),
      Plurimath::Math::Symbol.new("↔"),
    )
  ])
  EX_151 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Underset.new(
      Plurimath::Math::Function::Text.new("e"),
      Plurimath::Math::Symbol.new("↔"),
    )
  ])
  EX_152 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Overset.new(
      Plurimath::Math::Function::Text.new("e"),
      Plurimath::Math::Symbol.new("⇔")
    )
  ])
  EX_153 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Underset.new(
      Plurimath::Math::Function::Text.new("e"),
      Plurimath::Math::Symbol.new("⇔"),
    )
  ])
  EX_154 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Underset.new(
      Plurimath::Math::Function::Text.new("yields"),
      Plurimath::Math::Symbol.new("&#x2192;"),
    )
  ])
  EX_155 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Underset.new(
      Plurimath::Math::Symbol.new("∆"),
      Plurimath::Math::Symbol.new("&#x2192;"),
    )
  ])
  EX_156 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Table.new(
      [
        Plurimath::Math::Function::Tr.new([
          Plurimath::Math::Function::Td.new([
            Plurimath::Math::Function::Text.new("a")
          ]),
          Plurimath::Math::Function::Td.new([
            Plurimath::Math::Function::Text.new("b")
          ])
        ])
      ],
      nil,
      nil
    )
  ])
  EX_157 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Table.new(
      [
        Plurimath::Math::Function::Tr.new([
          Plurimath::Math::Function::Td.new([
            Plurimath::Math::Function::Text.new("a")
          ])
        ]),
        Plurimath::Math::Function::Tr.new([
          Plurimath::Math::Function::Td.new([
            Plurimath::Math::Function::Text.new("b")
          ])
        ])
      ],
      nil,
      nil
    )
  ])
  EX_158 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Table.new(
      [
        Plurimath::Math::Function::Tr.new([
          Plurimath::Math::Function::Td.new([
            Plurimath::Math::Function::Text.new("a")
          ]),
          Plurimath::Math::Function::Td.new([
            Plurimath::Math::Function::Text.new("b")
          ]),
          Plurimath::Math::Function::Td.new([
            Plurimath::Math::Function::Text.new("c")
          ])
        ])
      ],
      nil,
      nil
    )
  ])
  EX_159 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Table.new(
      [
        Plurimath::Math::Function::Tr.new([
          Plurimath::Math::Function::Td.new([
            Plurimath::Math::Function::Text.new("a")
          ])
        ]),
        Plurimath::Math::Function::Tr.new([
          Plurimath::Math::Function::Td.new([
            Plurimath::Math::Function::Text.new("b")
          ])
        ]),
        Plurimath::Math::Function::Tr.new([
          Plurimath::Math::Function::Td.new([
            Plurimath::Math::Function::Text.new("c")
          ])
        ])
      ],
      nil,
      nil
    )
  ])
  EX_160 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Table.new(
      [
        Plurimath::Math::Function::Tr.new([
          Plurimath::Math::Function::Td.new([
            Plurimath::Math::Function::Text.new("b")
          ]),
          Plurimath::Math::Function::Td.new([
            Plurimath::Math::Function::Text.new("c")
          ])
        ]),
        Plurimath::Math::Function::Tr.new([
          Plurimath::Math::Function::Td.new([
            Plurimath::Math::Function::Text.new("d")
          ]),
          Plurimath::Math::Function::Td.new([
            Plurimath::Math::Function::Text.new("e")
          ])
        ])
      ],
      nil,
      nil
    )
  ])
  EX_161 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Table.new(
      [
        Plurimath::Math::Function::Tr.new([
          Plurimath::Math::Function::Td.new([
            Plurimath::Math::Function::Text.new("b")
          ]),
          Plurimath::Math::Function::Td.new([
            Plurimath::Math::Function::Text.new("c")
          ]),
          Plurimath::Math::Function::Td.new([
            Plurimath::Math::Function::Text.new("d")
          ])
        ]),
        Plurimath::Math::Function::Tr.new([
          Plurimath::Math::Function::Td.new([
            Plurimath::Math::Function::Text.new("e")
          ]),
          Plurimath::Math::Function::Td.new([
            Plurimath::Math::Function::Text.new("f")
          ]),
          Plurimath::Math::Function::Td.new([
            Plurimath::Math::Function::Text.new("g")
          ]),
        ])
      ],
      nil,
      nil
    )
  ])
  EX_162 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Table.new(
      [
        Plurimath::Math::Function::Tr.new([
          Plurimath::Math::Function::Td.new([
            Plurimath::Math::Function::Text.new("b")
          ]),
          Plurimath::Math::Function::Td.new([
            Plurimath::Math::Function::Text.new("c")
          ])
        ]),
        Plurimath::Math::Function::Tr.new([
          Plurimath::Math::Function::Td.new([
            Plurimath::Math::Function::Text.new("d")
          ]),
          Plurimath::Math::Function::Td.new([
            Plurimath::Math::Function::Text.new("e")
          ])
        ]),
        Plurimath::Math::Function::Tr.new([
          Plurimath::Math::Function::Td.new([
            Plurimath::Math::Function::Text.new("f")
          ]),
          Plurimath::Math::Function::Td.new([
            Plurimath::Math::Function::Text.new("g")
          ])
        ])
      ],
      nil,
      nil
    )
  ])
  EX_163 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Table.new(
      [
        Plurimath::Math::Function::Tr.new([
          Plurimath::Math::Function::Td.new([
            Plurimath::Math::Number.new("1")
          ]),
          Plurimath::Math::Function::Td.new([
            Plurimath::Math::Number.new("2")
          ]),
          Plurimath::Math::Function::Td.new([
            Plurimath::Math::Number.new("3")
          ])
        ]),
        Plurimath::Math::Function::Tr.new([
          Plurimath::Math::Function::Td.new([
            Plurimath::Math::Number.new("4")
          ]),
          Plurimath::Math::Function::Td.new([
            Plurimath::Math::Number.new("5")
          ]),
          Plurimath::Math::Function::Td.new([
            Plurimath::Math::Number.new("6")
          ])
        ]),
        Plurimath::Math::Function::Tr.new([
          Plurimath::Math::Function::Td.new([
            Plurimath::Math::Number.new("7")
          ]),
          Plurimath::Math::Function::Td.new([
            Plurimath::Math::Number.new("8")
          ]),
          Plurimath::Math::Function::Td.new([
            Plurimath::Math::Number.new("9")
          ])
        ])
      ],
      nil,
      nil
    )
  ])
  EX_164 = Plurimath::Math::Formula.new([
    Plurimath::Math::Symbol.new("⋯")
  ])
  EX_165 = Plurimath::Math::Formula.new([
    Plurimath::Math::Symbol.new("…")
  ])
  EX_166 = Plurimath::Math::Formula.new([
    Plurimath::Math::Symbol.new("⋮")
  ])
  EX_167 = Plurimath::Math::Formula.new([
    Plurimath::Math::Symbol.new("⋱")
  ])
  EX_168 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Table.new(
      [
        Plurimath::Math::Function::Tr.new([
          Plurimath::Math::Function::Td.new([
            Plurimath::Math::Number.new("1")
          ]),
          Plurimath::Math::Function::Td.new([
            Plurimath::Math::Number.new("0")
          ])
        ]),
        Plurimath::Math::Function::Tr.new([
          Plurimath::Math::Function::Td.new([
            Plurimath::Math::Number.new("0")
          ]),
          Plurimath::Math::Function::Td.new([
            Plurimath::Math::Number.new("1")
          ])
        ])
      ],
      nil,
      nil
    )
  ])
  EX_169 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Table.new(
      [
        Plurimath::Math::Function::Tr.new([
          Plurimath::Math::Function::Td.new([
            Plurimath::Math::Number.new("1")
          ]),
          Plurimath::Math::Function::Td.new([]),
        ]),
        Plurimath::Math::Function::Tr.new([
          Plurimath::Math::Function::Td.new([]),
          Plurimath::Math::Function::Td.new([
            Plurimath::Math::Number.new("1")
          ]),
        ])
      ],
      nil,
      nil
    )
  ])
  EX_170 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Table.new(
      [
        Plurimath::Math::Function::Tr.new([
          Plurimath::Math::Function::Td.new([
            Plurimath::Math::Number.new("1")
          ]),
          Plurimath::Math::Function::Td.new([
            Plurimath::Math::Number.new("0")
          ]),
          Plurimath::Math::Function::Td.new([
            Plurimath::Math::Number.new("0")
          ])
        ]),
        Plurimath::Math::Function::Tr.new([
          Plurimath::Math::Function::Td.new([
            Plurimath::Math::Number.new("0")
          ]),
          Plurimath::Math::Function::Td.new([
            Plurimath::Math::Number.new("1")
          ]),
          Plurimath::Math::Function::Td.new([
            Plurimath::Math::Number.new("0")
          ])
        ]),
        Plurimath::Math::Function::Tr.new([
          Plurimath::Math::Function::Td.new([
            Plurimath::Math::Number.new("0")
          ]),
          Plurimath::Math::Function::Td.new([
            Plurimath::Math::Number.new("0")
          ]),
          Plurimath::Math::Function::Td.new([
            Plurimath::Math::Number.new("1")
          ])
        ])
      ],
      nil,
      nil
    )
  ])
  EX_171 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Table.new(
      [
        Plurimath::Math::Function::Tr.new([
          Plurimath::Math::Function::Td.new([
            Plurimath::Math::Number.new("1")
          ]),
          Plurimath::Math::Function::Td.new([]),
          Plurimath::Math::Function::Td.new([]),
        ]),
        Plurimath::Math::Function::Tr.new([
          Plurimath::Math::Function::Td.new([]),
          Plurimath::Math::Function::Td.new([
            Plurimath::Math::Number.new("1")
          ]),
          Plurimath::Math::Function::Td.new([]),
        ]),
        Plurimath::Math::Function::Tr.new([
          Plurimath::Math::Function::Td.new([]),
          Plurimath::Math::Function::Td.new([]),
          Plurimath::Math::Function::Td.new([
            Plurimath::Math::Number.new("1")
          ])
        ])
      ],
      nil,
      nil
    )
  ])
  EX_172 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Fenced.new(
      nil,
      [
        Plurimath::Math::Function::Table.new(
          [
            Plurimath::Math::Function::Tr.new([
              Plurimath::Math::Function::Td.new([
                Plurimath::Math::Number.new("1")
              ]),
              Plurimath::Math::Function::Td.new([
                Plurimath::Math::Number.new("1")
              ])
            ]),
            Plurimath::Math::Function::Tr.new([
              Plurimath::Math::Function::Td.new([
                Plurimath::Math::Number.new("0")
              ]),
              Plurimath::Math::Function::Td.new([
                Plurimath::Math::Number.new("0")
              ])
            ])
          ],
          nil,
          nil
        )
      ],
      nil,
    )
  ])
  EX_173 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Fenced.new(
      Plurimath::Math::Symbol.new("["),
      [
        Plurimath::Math::Function::Table.new(
          [
            Plurimath::Math::Function::Tr.new([
              Plurimath::Math::Function::Td.new([
                Plurimath::Math::Number.new("1")
              ]),
              Plurimath::Math::Function::Td.new([
                Plurimath::Math::Number.new("1")
              ])
            ]),
            Plurimath::Math::Function::Tr.new([
              Plurimath::Math::Function::Td.new([
                Plurimath::Math::Number.new("0")
              ]),
              Plurimath::Math::Function::Td.new([
                Plurimath::Math::Number.new("0")
              ])
            ])
          ],
          nil,
          nil
        )
      ],
      Plurimath::Math::Symbol.new("]"),
    )
  ])
  EX_174 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Fenced.new(
      Plurimath::Math::Symbol.new("|"),
      [
        Plurimath::Math::Function::Table.new(
          [
            Plurimath::Math::Function::Tr.new([
              Plurimath::Math::Function::Td.new([
                Plurimath::Math::Number.new("1")
              ]),
              Plurimath::Math::Function::Td.new([
                Plurimath::Math::Number.new("1")
              ])
            ]),
            Plurimath::Math::Function::Tr.new([
              Plurimath::Math::Function::Td.new([
                Plurimath::Math::Number.new("0")
              ]),
              Plurimath::Math::Function::Td.new([
                Plurimath::Math::Number.new("0")
              ])
            ])
          ],
          nil,
          nil
        )
      ],
      Plurimath::Math::Symbol.new("|"),
    )
  ])
  EX_175 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Fenced.new(
      Plurimath::Math::Symbol.new("‖"),
      [
        Plurimath::Math::Function::Table.new(
          [
            Plurimath::Math::Function::Tr.new([
              Plurimath::Math::Function::Td.new([
                Plurimath::Math::Number.new("1")
              ]),
              Plurimath::Math::Function::Td.new([
                Plurimath::Math::Number.new("1")
              ])
            ]),
            Plurimath::Math::Function::Tr.new([
              Plurimath::Math::Function::Td.new([
                Plurimath::Math::Number.new("0")
              ]),
              Plurimath::Math::Function::Td.new([
                Plurimath::Math::Number.new("0")
              ])
            ])
          ],
          nil,
          nil
        )
      ],
      Plurimath::Math::Symbol.new("‖"),
    )
  ])
  EX_176 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Fenced.new(
      nil,
      [
        Plurimath::Math::Function::Table.new(
          [
            Plurimath::Math::Function::Tr.new([
              Plurimath::Math::Function::Td.new([
                Plurimath::Math::Function::Text.new( "a")
              ]),
              Plurimath::Math::Function::Td.new([
                Plurimath::Math::Symbol.new("⋯")
              ]),
              Plurimath::Math::Function::Td.new([
                Plurimath::Math::Function::Text.new( "b")
              ])
            ]),
            Plurimath::Math::Function::Tr.new([
              Plurimath::Math::Function::Td.new([
                Plurimath::Math::Symbol.new("⋮")
              ]),
              Plurimath::Math::Function::Td.new([
                Plurimath::Math::Symbol.new("⋱")
              ]),
              Plurimath::Math::Function::Td.new([
                Plurimath::Math::Symbol.new("⋮")
              ])
            ]),
            Plurimath::Math::Function::Tr.new([
              Plurimath::Math::Function::Td.new([
                Plurimath::Math::Function::Text.new( "c")
              ]),
              Plurimath::Math::Function::Td.new([
                Plurimath::Math::Symbol.new("⋯")
              ]),
              Plurimath::Math::Function::Td.new([
                Plurimath::Math::Function::Text.new( "d")
              ])
            ])
          ],
          nil,
          nil
        )
      ],
      nil,
    )
  ])
  EX_177 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Fenced.new(
      Plurimath::Math::Symbol.new("["),
      [
        Plurimath::Math::Function::Table.new(
          [
            Plurimath::Math::Function::Tr.new([
              Plurimath::Math::Function::Td.new([
                Plurimath::Math::Function::Text.new( "a")
              ]),
              Plurimath::Math::Function::Td.new([
                Plurimath::Math::Symbol.new("⋯")
              ]),
              Plurimath::Math::Function::Td.new([
                Plurimath::Math::Function::Text.new( "b")
              ])
            ]),
            Plurimath::Math::Function::Tr.new([
              Plurimath::Math::Function::Td.new([
                Plurimath::Math::Symbol.new("⋮")
              ]),
              Plurimath::Math::Function::Td.new([
                Plurimath::Math::Symbol.new("⋱")
              ]),
              Plurimath::Math::Function::Td.new([
                Plurimath::Math::Symbol.new("⋮")
              ])
            ]),
            Plurimath::Math::Function::Tr.new([
              Plurimath::Math::Function::Td.new([
                Plurimath::Math::Function::Text.new( "d")
              ]),
              Plurimath::Math::Function::Td.new([
                Plurimath::Math::Symbol.new("⋯")
              ]),
              Plurimath::Math::Function::Td.new([
                Plurimath::Math::Function::Text.new( "c")
              ])
            ])
          ],
          nil,
          nil
        )
      ],
      Plurimath::Math::Symbol.new("]"),
    )
  ])
  EX_178 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Limits.new(
      Plurimath::Math::Function::Int.new,
      Plurimath::Math::Number.new("0"),
      Plurimath::Math::Function::PowerBase.new(
        Plurimath::Math::Symbol.new("&#x3C0;"),
        Plurimath::Math::Number.new("2221"),
        Plurimath::Math::Symbol.new("&#x2221;"),
      ),
    )
  ])
  EX_179 = Plurimath::Math::Formula.new([
    Plurimath::Math::Symbol.new("S"),
    Plurimath::Math::Function::Fenced.new(
      Plurimath::Math::Symbol.new("("),
      [
        Plurimath::Math::Symbol.new("u"),
        Plurimath::Math::Symbol.new(","),
        Plurimath::Math::Symbol.new("v")
      ],
      Plurimath::Math::Symbol.new(")"),
    ),
    Plurimath::Math::Symbol.new("="),
    Plurimath::Math::Function::Sum.new(
      Plurimath::Math::Formula.new([
        Plurimath::Math::Symbol.new("i"),
        Plurimath::Math::Symbol.new("="),
        Plurimath::Math::Number.new("0")
      ]),
      Plurimath::Math::Number.new("3"),
      Plurimath::Math::Function::Prod.new(
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("j"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Number.new("0")
        ]),
        Plurimath::Math::Number.new("3"),
        Plurimath::Math::Function::Base.new(
          Plurimath::Math::Symbol.new("p"),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbol.new("i"),
            Plurimath::Math::Symbol.new("j")
          ])
        )
      )
    ),
    Plurimath::Math::Symbol.new("&#xd7;"),
    Plurimath::Math::Function::Base.new(
      Plurimath::Math::Symbol.new("B"),
      Plurimath::Math::Symbol.new("i"),
    ),
    Plurimath::Math::Function::Fenced.new(
      Plurimath::Math::Symbol.new("("),
      [
        Plurimath::Math::Symbol.new("u"),
      ],
      Plurimath::Math::Symbol.new(")"),
    ),
    Plurimath::Math::Symbol.new("&#xd7;"),
    Plurimath::Math::Function::Base.new(
      Plurimath::Math::Symbol.new("B"),
      Plurimath::Math::Symbol.new("j"),
    ),
    Plurimath::Math::Function::Fenced.new(
      Plurimath::Math::Symbol.new("("),
      [
        Plurimath::Math::Symbol.new("v"),
      ],
      Plurimath::Math::Symbol.new(")"),
    )
  ])
  EX_180 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Sum.new(
      Plurimath::Math::Function::Prod.new,
      Plurimath::Math::Symbol.new("i"),
      Plurimath::Math::Function::Int.new(
        Plurimath::Math::Formula.new([
          Plurimath::Math::Symbol.new("j"),
          Plurimath::Math::Symbol.new("="),
          Plurimath::Math::Number.new("0")
        ]),
        nil,
        Plurimath::Math::Function::Base.new(
          Plurimath::Math::Symbol.new("p"),
          Plurimath::Math::Formula.new([
            Plurimath::Math::Symbol.new("i"),
            Plurimath::Math::Symbol.new("j")
          ])
        )
      )
    ),
  ])
  EX_181 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Underover.new(
      Plurimath::Math::Symbol.new("&#x22c2;"),
      Plurimath::Math::Formula.new([
        Plurimath::Math::Symbol.new("i"),
        Plurimath::Math::Symbol.new("&#x2208;"),
        Plurimath::Math::Symbol.new("I")
      ]),
      Plurimath::Math::Symbol.new("n"),
    )
  ])
  EX_182 = Plurimath::Math::Formula.new([
    Plurimath::Math::Formula.new([
      Plurimath::Math::Function::PowerBase.new(
        Plurimath::Math::Function::Prod.new,
        Plurimath::Math::Symbol.new("d"),
        Plurimath::Math::Number.new("1"),
      ),
      Plurimath::Math::Symbol.new("c"),
    ]),
  ])
  EX_183 = Plurimath::Math::Formula.new([
    Plurimath::Math::Formula.new([
      Plurimath::Math::Function::PowerBase.new(
        Plurimath::Math::Function::Sum.new,
        Plurimath::Math::Symbol.new("d"),
        Plurimath::Math::Number.new("1"),
      ),
      Plurimath::Math::Symbol.new("c"),
    ]),
  ])
  EX_184 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::FontStyle::Normal.new(
      Plurimath::Math::Number.new("100"),
      "p"
    ),
    Plurimath::Math::Function::FontStyle::Bold.new(
      Plurimath::Math::Function::Text.new("a"),
      "b"
    ),
    Plurimath::Math::Function::FontStyle::Italic.new(
      Plurimath::Math::Function::Text.new("a"),
      "i"
    ),
    Plurimath::Math::Function::FontStyle::BoldItalic.new(
      Plurimath::Math::Function::Text.new("a"),
      "bi"
    ),
    Plurimath::Math::Function::FontStyle::DoubleStruck.new(
      Plurimath::Math::Function::Text.new("a"),
      "double-struck"
    ),
    Plurimath::Math::Function::FontStyle::BoldFraktur.new(
      Plurimath::Math::Function::Text.new("a"),
      "fraktur-b"
    ),
    Plurimath::Math::Function::FontStyle::Script.new(
      Plurimath::Math::Function::Text.new("a"),
      "script-p"
    ),
    Plurimath::Math::Function::FontStyle::BoldScript.new(
      Plurimath::Math::Function::Text.new("a"),
      "script-b"
    ),
    Plurimath::Math::Function::FontStyle::Fraktur.new(
      Plurimath::Math::Function::Text.new("a"),
      "fraktur-p"
    ),
    Plurimath::Math::Function::FontStyle::SansSerif.new(
      Plurimath::Math::Function::Text.new("a"),
      "sans-serif-p"
    ),
    Plurimath::Math::Function::FontStyle::BoldSansSerif.new(
      Plurimath::Math::Function::Text.new("a"),
      "sans-serif-b"
    ),
    Plurimath::Math::Function::FontStyle::SansSerifItalic.new(
      Plurimath::Math::Function::Text.new("a"),
      "sans-serif-i"
    ),
    Plurimath::Math::Function::FontStyle::SansSerifBoldItalic.new(
      Plurimath::Math::Function::Text.new("a"),
      "sans-serif-bi"
    ),
    Plurimath::Math::Function::FontStyle::Monospace.new(
      Plurimath::Math::Function::Text.new("a"),
      "monospace"
    )
  ])
  EX_185 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Overset.new(
      Plurimath::Math::Symbol.new("_"),
      Plurimath::Math::Function::Text.new("under"),
    )
  ])
  EX_186 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Underset.new(
      Plurimath::Math::Symbol.new("⏟"),
      Plurimath::Math::Function::Text.new("under"),
    )
  ])
  EXIssue158 = Plurimath::Math::Formula.new([
    Plurimath::Math::Function::Text.new("U="),
    Plurimath::Math::Function::Fenced.new(
      Plurimath::Math::Symbol.new("{"),
      [
        Plurimath::Math::Function::Table.new(
          [
            Plurimath::Math::Function::Tr.new([
              Plurimath::Math::Function::Td.new([
                Plurimath::Math::Function::Base.new(
                  Plurimath::Math::Function::Text.new("Q"),
                  Plurimath::Math::Function::Text.new("e")
                ),
                Plurimath::Math::Function::Text.new("*E"),
                Plurimath::Math::Symbol.new(",  &"),
                Plurimath::Math::Function::Text.new("if"),
                Plurimath::Math::Symbol.new(" "),
                Plurimath::Math::Function::Base.new(
                  Plurimath::Math::Function::Text.new("Q"),
                  Plurimath::Math::Function::Text.new("e")
                ),
                Plurimath::Math::Symbol.new("<1")
              ])
            ]),
            Plurimath::Math::Function::Tr.new([
              Plurimath::Math::Function::Td.new([
                Plurimath::Math::Function::Text.new("E,  &"),
                Plurimath::Math::Function::Text.new("if "),
                Plurimath::Math::Function::Base.new(
                  Plurimath::Math::Function::Text.new("Q"),
                  Plurimath::Math::Function::Text.new("e")
                ),
                Plurimath::Math::Function::Text.new("<S")
              ])
            ]),
            Plurimath::Math::Function::Tr.new([
              Plurimath::Math::Function::Td.new([
                Plurimath::Math::Function::Fenced.new(
                  nil,
                  [
                    Plurimath::Math::Function::Fenced.new(
                      Plurimath::Math::Symbol.new("⌊"),
                      [
                        Plurimath::Math::Function::Frac.new(
                          Plurimath::Math::Function::Base.new(
                            Plurimath::Math::Function::Text.new("Q"),
                            Plurimath::Math::Function::Text.new("e")
                          ),
                          Plurimath::Math::Function::Text.new("S"),
                        )
                      ],
                      Plurimath::Math::Symbol.new("⌋"),
                    ),
                    Plurimath::Math::Symbol.new("+"),
                    Plurimath::Math::Function::Fenced.new(
                      Plurimath::Math::Symbol.new("⌈"),
                      [
                        Plurimath::Math::Function::Frac.new(
                          Plurimath::Math::Formula.new([
                            Plurimath::Math::Function::Base.new(
                              Plurimath::Math::Function::Text.new("Q"),
                              Plurimath::Math::Function::Text.new("e")
                            ),
                            Plurimath::Math::Function::Text.new("mod S")
                          ]),
                          Plurimath::Math::Function::Text.new("S"),
                        )
                      ],
                      Plurimath::Math::Symbol.new("⌉"),
                    ),
                    Plurimath::Math::Symbol.new(" ")
                  ],
                  nil,
                ),
                Plurimath::Math::Function::Text.new("E,  &"),
                Plurimath::Math::Function::Text.new("otherwise")
              ])
            ])
          ],
          nil,
          nil
        )
      ],
      nil,
    )
  ])
end
