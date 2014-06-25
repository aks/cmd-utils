# lookup.rb -- simple keyword lookup routine
#
# Alan K. Stebbens <aks@stebbens.org>
#
#    require 'lookup'
#
# lookup - lookup a keyword in a list, in a case-insensitive, disambiguous way
#
# :call-seq:
#     result = lookup list, key, err_notfound="%s not found", err_ambig="% is ambiguous"
#     result = list.lookup( key, err_notfound, err_ambig )
#     result = list.lookup( key, err_notfound )
#     result = list.lookup( key )
#
# Lookup key in list, which can be an array or a hash.  Return the one that
# matches exactly, or matches using case-insensitive, unambiguous matches, or
# raise a LookupError with a message.
#
# LookupError is a subclass of StandardError.
#
# LookupNotFoundError, a subclass of LookupError, is raised when a keyword is
# not found, and only if `err_notfound` is not nil.
#
# LookupAmbigError, a subsclass of LookupError, is raised when a keyword search
# matches multiple entries from the list, and only if `err_ambig` is not nil.
#
# If err_notfound is nil, do not raise a LookupNotFoundError error, and return
# nil.
#
# If err_ambigmsg is nil, do not raise a LookupAmbigError, and return the list
# of possible results.

class LookupError         < StandardError ; end
class LookupNotFoundError < LookupError ; end
class LookupAmbigError    < LookupError ; end

def key_lookup list, key, err_notfound="%s not found\n", err_ambig="%s is ambiguous\n"
  keylist = list.is_a?(Hash) ? list.keys : list
  if exact = keylist.grep(/^#{key}$/i)         # exact match?
    return exact.shift if exact && exact.size == 1
  end
  keys = keylist.grep(/^#{key}/i)
  case keys.size
  when 0
    unless err_notfound.nil?
      raise LookupNotFoundError, sprintf(err_notfound, key)
    end
    return nil
  when 1
    return keys[0]
  else
    unless err_ambig.nil?
      raise LookupAmbigError, sprintf(err_ambig, key)
    end
    return keys
  end
end

alias lookup key_lookup

class Array
  def lookup key, err_notfound="%s not found\n", err_ambig="%s is ambiguous\n"
    key_lookup self, key, err_notfound, err_ambig
  end
end

class Hash
  def lookup key, err_notfound="%s not found\n", err_ambig="%s is ambiguous\n"
    self.keys.lookup(key, err_notfound, err_ambig)
  end
end

# end of lookup.rb
# vim: set sw=2 ai
