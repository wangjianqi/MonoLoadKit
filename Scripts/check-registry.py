#!/usr/bin/env python3
"""Checks style/render registry consistency without relying on Apple SDKs."""
from pathlib import Path
import re
ROOT = Path(__file__).resolve().parents[1]
style = (ROOT / 'Sources/MonoLoadKit/MonoLoadingStyle.swift').read_text()
painter = (ROOT / 'Sources/MonoLoadKit/MonoLoadingPainter.swift').read_text()
demo = (ROOT / 'Examples/MonoLoadDemo/MonoLoadDemo/DemoGalleryView.swift').read_text()
case_block = style.split('public enum MonoLoadingStyle:', 1)[1].split('public var id:', 1)[0]
cases = re.findall(r'\bcase\s+(\w+)\s*$', case_block, flags=re.M)
draws = re.findall(r'private func draw(\w+)\(\)', painter)
dispatch = re.findall(r'case \.(\w+): draw(\w+)\(\)', painter)
assert len(cases) == 32, f'Expected 32 style declarations, found {len(cases)}'
assert len(set(cases)) == 32
assert len(draws) == 32 and len(set(draws)) == 32
assert len(dispatch) == 32
for case, func in dispatch:
    assert case in cases, f'Missing public enum style {case}'
    assert func == case[0].upper() + case[1:], f'Unexpected mapping: {case} -> {func}'
    assert func in draws, f'Missing draw function for {case}'
assert 'TimelineView' in demo and 'MonoLoadingGlyph' in demo, 'Missing shared gallery timeline'
assert not (ROOT / '.github/workflows').exists(), 'Unexpected GitHub Actions configuration'
print('Registry OK: 32 styles, 32 painters, 32 dispatch mappings; demo timeline present')
