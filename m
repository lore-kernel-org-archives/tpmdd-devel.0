From: Ken Goldman <kgoldman-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: TPM 2.0 RM flushcontext
Date: Tue, 10 Jan 2017 15:01:16 -0500
Message-ID: <o53ei5$sc5$1@blaine.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

1 - Is this the correct place to post potential RM issues?

2 - Here's my test case:

test0: primary key 80ffffff
test0: signing key 0 80fffffe
test0: signing key 1 80fffffd
test0: session 02000000
test0: sign with 02000000 80fffffe
test0: sign with 02000000 80fffffd
	listTransientObjects: 80000000
	listTransientObjects: 80000001
	listTransientObjects: 80000002
test0: flush 80fffffe
rmtest: failed, rc 000001c4
TPM_RC_VALUE - value is out of range or is not correct for the context 
Parameter number 1

The signing key at 80fffffe exists, because I can sign with it. 
However, the flush fails.

3 - I thought that perhaps the RM was not handling flushcontext yet. 
When I tried to flush 80000002, the write() fails.

TSS_Dev_SendCommand: write error 14 Bad address

So it seems that the RM is doing something with the flushcontext handle.

4 - Is a write() error desirable?  I think the application would prefer 
a TPM formatted response like TPM_RC_VALUE.

Would it be easy to hard code this response for any handle mapping error?

80 01 00 00 00 0a 00 00 00 c4




------------------------------------------------------------------------------
Developer Access Program for Intel Xeon Phi Processors
Access to Intel Xeon Phi processor-based developer platforms.
With one year of Intel Parallel Studio XE.
Training and support from Colfax.
Order your platform today. http://sdm.link/xeonphi
