<%!
from asciidoxy.generator.templates.helpers import h1
from asciidoxy.generator.templates.cpp.helpers import CppTemplateHelper
from html import escape
%>

[#${element.id},reftext='${element.full_name}']
${h1(leveloffset, element.name)}
${api.inserted(element)}

${element.brief}

${element.description}
