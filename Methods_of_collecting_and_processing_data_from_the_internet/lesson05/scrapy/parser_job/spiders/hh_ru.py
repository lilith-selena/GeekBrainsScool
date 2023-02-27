import scrapy
from scrapy.http import HtmlRespons


class HhRuSpider(scrapy.Spider):
    name = 'hh_ru'
    allowed_domains = ['hh.ru']
    start_urls = ['https://hh.ru/search/vacancy?text=Data+analyst&from=suggest_post&area=1']

    def parse(self, response:HtmlRespons):
        print('\n###################\n%s\n###################\n'%response.url)
