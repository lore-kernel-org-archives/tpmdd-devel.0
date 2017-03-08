From: Roberto Sassu <roberto.sassu-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: Support for Crypto Agile format in IMA
Date: Wed, 8 Mar 2017 18:11:08 +0100
Message-ID: <60a3a2ff-77b6-c0ad-a647-99a6244b2f3a@huawei.com>
References: <D1203BA5BAF1AF4DAC3967497AD1E070B74F64@lhreml502-mbs>
	<1488906121.3216.76.camel@linux.vnet.ibm.com>
	<c3469990-bc82-0fa5-1bfd-2ef1695acaf4@huawei.com>
	<1488921155.21855.5.camel@linux.vnet.ibm.com>
	<3fdfbe53-9d33-03d9-535d-4d3330fdb186@huawei.com>
	<1488990561.7249.21.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1488990561.7249.21.camel-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: "linux-ima-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <linux-ima-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Silviu Vlasceanu <Silviu.Vlasceanu-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On 3/8/2017 5:29 PM, Mimi Zohar wrote:
> The reason for extending multiple TPM banks is to prevent user space
> from being able to extend unused TPM banks with whatever they want and
> then quote those banks, based on a bogus list.  I wouldn't say that
> padding/truncating the unused TPM banks is a standard, but something
> that is needed.

The problem is that by doing this for each measurement, the boot time
will increase significantly due to the higher number of extend
operations.

Preventing use of unused banks can be achieved by extending all PCR
banks with a known value only once during IMA initialization and
reporting this in the event log. Example:

0 0000... ima-header sha1:20|sha256:32
10 sha1:ffff...|sha256:<digest> ima-ng sha1:<digest> boot_aggregate


> By extending multiple TPM banks, the IMA measurement list can then be
> validated against any bank, assuming that it is padded/truncated
> appropriately.

Another benefit of the proposal above is that verifiers do not
need to know how digests are padded/truncated, as the event log
will report the digest for each bank.

Roberto

------------------------------------------------------------------------------
Announcing the Oxford Dictionaries API! The API offers world-renowned
dictionary content that is easy and intuitive to access. Sign up for an
account today to start using our lexical data to power your apps and
projects. Get started today and enter our developer competition.
http://sdm.link/oxford
