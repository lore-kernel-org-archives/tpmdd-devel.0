From: Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: Support for Crypto Agile format in IMA
Date: Wed, 08 Mar 2017 11:29:21 -0500
Message-ID: <1488990561.7249.21.camel@linux.vnet.ibm.com>
References: <D1203BA5BAF1AF4DAC3967497AD1E070B74F64@lhreml502-mbs>
	<1488906121.3216.76.camel@linux.vnet.ibm.com>
	<c3469990-bc82-0fa5-1bfd-2ef1695acaf4@huawei.com>
	<1488921155.21855.5.camel@linux.vnet.ibm.com>
	<3fdfbe53-9d33-03d9-535d-4d3330fdb186@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <3fdfbe53-9d33-03d9-535d-4d3330fdb186-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Roberto Sassu <roberto.sassu-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: "linux-ima-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <linux-ima-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Silviu Vlasceanu <Silviu.Vlasceanu-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, 2017-03-08 at 10:58 +0100, Roberto Sassu wrote:
> On 3/7/2017 10:12 PM, Mimi Zohar wrote:
> > With the "header" and boot-aggregate records for each kexec, the
> > attestation server can determine which hash algorithm was used for
> > extending the different TPM banks.   The attestation server can then
> > pad/truncate the hash as needed, when verifying the TPM quote.
> 
> According to the TCG specs, there should be just one header
> at the beginning of the list. Its purpose is to provide the length
> for each hash algorithm supported by the TPM. The subset of algorithms
> used is defined per measurement entry.
> 
> Regarding modifying the digest before it is passed to the extend
> function, can truncating/padding with zeros be considered
> a standard? If not, verifiers have to look at the software
> implementation, in order to find how the digest was modified.
> I add in CC tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org also here.

The reason for extending multiple TPM banks is to prevent user space
from being able to extend unused TPM banks with whatever they want and
then quote those banks, based on a bogus list.  I wouldn't say that
padding/truncating the unused TPM banks is a standard, but something
that is needed.

By extending multiple TPM banks, the IMA measurement list can then be
validated against any bank, assuming that it is padded/truncated
appropriately.  

At some point, we should probably add support for calculating multiple
hashes and including them in the IMA measurement list.

Mimi


------------------------------------------------------------------------------
Announcing the Oxford Dictionaries API! The API offers world-renowned
dictionary content that is easy and intuitive to access. Sign up for an
account today to start using our lexical data to power your apps and
projects. Get started today and enter our developer competition.
http://sdm.link/oxford
