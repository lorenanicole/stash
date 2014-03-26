
class Clear(object):
    def __init__(self):
        self.val = '~'
        self.rows = 100
        self.width = 40
        self.increment = 1

    def run(self):
        i = 0
        for x in xrange(self.rows):
            str = " " * i
            str += self.val
            print str
            i += self.increment
            if i >= self.width or i <= 0:
                self.increment *= -1

if __name__ == '__main__':
    c = Clear()
    c.run()