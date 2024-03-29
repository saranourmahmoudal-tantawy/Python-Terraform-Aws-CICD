import unittest
from my_package.main import app

class TestApp(unittest.TestCase):
    def setUp(self):
        self.app = app.test_client()

    def test_get_item(self):
        response = self.app.get('/item/chair')
        self.assertEqual(response.status_code, 200)
        self.assertIn(b'chair', response.data)

    def test_get_nonexistent_item(self):
        response = self.app.get('/item/nonexistent')
        self.assertEqual(response.status_code, 404)

    def test_post_item(self):
        data = {'price': '15.00'}
        response = self.app.post('/item/table', json=data)
        self.assertEqual(response.status_code, 201)
        self.assertIn(b'table', response.data)

    def test_get_item_list(self):
        response = self.app.get('/items')
        self.assertEqual(response.status_code, 200)
        self.assertIn(b'chair', response.data)

if __name__ == '__main__':
    unittest.main()