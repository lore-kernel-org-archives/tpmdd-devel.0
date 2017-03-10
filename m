From: Ken Goldman <kgold-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: Support for Crypto Agile format in IMA
Date: Fri, 10 Mar 2017 10:36:48 -0500
Message-ID: <524b8d73-b8f9-8793-f34c-97f7ec491076@linux.vnet.ibm.com>
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
Cc: "linux-ima-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <linux-ima-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On 3/8/2017 4:58 AM, Roberto Sassu wrote:
>
> Regarding modifying the digest before it is passed to the extend
> function, can truncating/padding with zeros be considered
> a standard? If not, verifiers have to look at the software
> implementation, in order to find how the digest was modified.
> I add in CC tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org also here.

It's not a TCG standard, just a way of making sure the unused PCR bank 
doesn't remain at zero, permitting forged measurements.

As for the verifier, I ignore the bank I'm not interested in.  I don't 
verify the truncated/padded bank.





------------------------------------------------------------------------------
Announcing the Oxford Dictionaries API! The API offers world-renowned
dictionary content that is easy and intuitive to access. Sign up for an
account today to start using our lexical data to power your apps and
projects. Get started today and enter our developer competition.
http://sdm.link/oxford
