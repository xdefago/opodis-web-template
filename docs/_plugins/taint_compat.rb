# Compatibility shim for Ruby 3.2+ where taint/un-taint were removed.
# Jekyll 3.x and Liquid 4.x still call these APIs; stub them to no-ops.
unless Object.method_defined?(:tainted?)
  class Object
    def tainted?; false; end
    def untaint; self; end
  end
end
